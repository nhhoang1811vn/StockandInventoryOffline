import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../../constant/constant.dart';
import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../base/base_state.dart';

part 'save_good_cubit.freezed.dart';
part 'save_good_state.dart';

@injectable
class SaveGoodCubit extends Cubit<SaveGoodState> {
  final GoodsUseCases useCase;
  final DocumentUseCases documentsUseCases;

  SaveGoodCubit({
    required this.useCase,
    required this.documentsUseCases,
  }) : super(SaveGoodState.initial(state: InitialState()));

  void initState() async {
    var minQuantitySettings = await AppSettings.getMinimumQuantitySettings();
    if (isClosed) return;
    emit(state.copyWith(showMinQuantity: minQuantitySettings.showInItem));
  }

  void init(Good item, Document? document, DocumentTransaction? transaction) {
    SaveGoodState initState = state.copyWith(
      item: item,
      document: document,
      name: (item.name.isNotEmpty)
          ? NameInput.dirty(value: item.name)
          : NameInput.pure(),
      description: item.description,
      barCode: item.barCode ?? '',
      purchasePrice: item.purchasePrice,
      salePrice: item.salePrice,
      minQuantity: item.minQuantity,
      files: item.files,
      transaction: transaction,
    );
    emit(initState);
  }

  Future<int> insertOrUpdateGood() async {
    Good item = state.item!;
    item.name = state.name.value;
    item.description = state.description;
    if (state.barCode.trim().isNotEmpty) {
      item.barCode = state.barCode.trim();
    }
    if (state.transaction == null) {
      item.purchasePrice = state.purchasePrice;
      item.salePrice = state.salePrice;
    }
    item.files = state.files;
    item.minQuantity = state.minQuantity;
    if (item.id == null) {
      item.id = await useCase.insert(item);
      if (!isClosed) {
        emit(state.copyWith(item: item));
      }
    } else {
      await useCase.update(item);
    }
    return item.id!;
  }

  Future<int> insertDocument(Document document) async {
    int documentId = await documentsUseCases.insert(document);
    return documentId;
  }

  void insertTransaction(DocumentTransaction item) async {
    documentsUseCases.insertTransaction(item);
  }

  void updateQuantity(double quantity) {
    Good item = state.item!;
    item.quantity += quantity;
    emit(state.copyWith(state: UpdateItemState(), item: item));
  }

  void onSaveClicked() async {
    final validate = Formz.validate([state.name]);
    if (validate) {
      try {
        var goodId = await insertOrUpdateGood();
        //insert document and insert transaction
        if (state.document != null) {
          //insert document
          Document document = state.document!;
          if (document.id == null) {
            int documentId = await documentsUseCases.insert(document);
            document.id = documentId;
          } else {
            await documentsUseCases.update(document);
          }
          //insert transaction
          if (state.transaction!.id != null) {
            await documentsUseCases.updateTransaction(state.transaction!);
          } else {
            DocumentTransaction transaction = state.transaction!;
            transaction.documentId = document.id!;
            //transaction.goodId = item.id!;
            transaction.goodId = goodId;
            await documentsUseCases.insertTransaction(transaction);
          }
          if (isClosed) return;
          emit(state.copyWith(state: SaveItemSuccessful(), document: document));
        } else {
          if (isClosed) return;
          emit(state.copyWith(state: SaveItemSuccessful()));
        }
      } catch (e) {
          if (isClosed) return;
          emit(state.copyWith(state: SaveItemError(e.toString())));
      }
    } else {
      emit(state.copyWith(name: NameInput.dirty(value: state.name.value)));
    }
  }

  void onHistoryClicked() async {
    final validate = Formz.validate([state.name]);
    if (validate) {
      try {
        await insertOrUpdateGood();
        if (isClosed) return;
        emit(state.copyWith(state: OpenHistoryPageState()));
      } catch (e) {
        if (isClosed) return;
        emit(state.copyWith(state: SaveItemError(e.toString())));
      }
    } else {
      emit(state.copyWith(name: NameInput.dirty(value: state.name.value)));
    }
  }

  void nameChanged(String value) {
    final name = NameInput.dirty(value: value);
    emit(state.copyWith(name: name));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void barCodeChanged(String value) {
    emit(state.copyWith(barCode: value));
  }

  void onImagesChanged(List<Uint8List> value) {
    emit(state.copyWith(files: value));
  }

  void onQuantityCalculatorPressed() {
    emit(state.copyWith(state: OpenCalculatorToInputQuantityState()));
  }

  void onPriceCalculatorPressed() {
    emit(state.copyWith(state: OpenCalculatorToInputPriceState()));
  }

  void onPurchasePriceCalculatorPressed() {
    emit(state.copyWith(state: OpenCalculatorToInputPurchasePriceState()));
  }

  void onSalePriceCalculatorPressed() {
    emit(state.copyWith(state: OpenCalculatorToInputSalePriceState()));
  }

  void onBarcodeScannerPressed() {
    emit(state.copyWith(state: OpenBarcodeScannerPageState()));
  }

  void quantityChanged(String value) {
    if (value.isNotEmpty) {
      DocumentTransaction current = state.transaction!;
      current.quantity = double.tryParse(value) ?? 0;
      emit(state.copyWith(transaction: current));
    }
  }

  void onPriceChanged(String value) {
    DocumentTransaction current = state.transaction!;
    if (value.isNotEmpty) {
      num numValue = Config.simpleCurrencyFormat.parse(value);
      double price = numValue.toDouble();
      current.price = price;
    } else {
      current.price = null;
    }
    emit(state.copyWith(transaction: current));
  }

  void onPurchasePriceChanged(String value) {
    if (value.isNotEmpty) {
      num numValue = Config.simpleCurrencyFormat.parse(value);
      double price = numValue.toDouble();
      emit(state.copyWith(purchasePrice: price));
    } else {
      emit(state.copyWith(purchasePrice: null));
    }
  }

  void onSalePriceChanged(String value) {
    if (value.isNotEmpty) {
      num numValue = Config.simpleCurrencyFormat.parse(value);
      double price = numValue.toDouble();
      emit(state.copyWith(salePrice: price));
    } else {
      emit(state.copyWith(salePrice: null));
    }
  }

  Future<void> onPlusQuantityButtonPressed() async {
    final validate = Formz.validate([state.name]);
    if (validate) {
      await insertOrUpdateGood();
      if (isClosed) return;
      emit(state.copyWith(state: OpenReceiveGoodsPopupState()));
    } else {
      emit(state.copyWith(name: NameInput.dirty(value: state.name.value)));
    }
  }

  Future<void> onMinusQuantityButtonPressed() async {
    final validate = Formz.validate([state.name]);
    if (validate) {
      await insertOrUpdateGood();
      if (isClosed) return;
      emit(state.copyWith(state: OpenIssueGoodsPopupState()));
    } else {
      emit(state.copyWith(name: NameInput.dirty(value: state.name.value)));
    }
  }

  void onMinQuantityChanged(String value) {
    num? numValue = Config.simpleCurrencyFormat.tryParse(value);
    if (numValue != null) {
      emit(state.copyWith(minQuantity: numValue.toDouble()));
    } else {
      emit(state.copyWith(minQuantity: null));
    }
  }

  int getSelectedStoreId() {
    return AppSettings.getSelectedStoreId();
  }

  int getAutoDocumentNo(int storeId) {
    return AppSettings.getAutoDocumentNo(storeId);
  }

  void onDeleteFile(int key) {
    List<Uint8List> items = [];
    items.addAll(state.files);
    items.removeAt(key);
    emit(state.copyWith(files: items));
  }
  void onAddFile(Uint8List bytes) {
    List<Uint8List> items = [];
    items.addAll(state.files);
    items.add(bytes);
    emit(state.copyWith(files: items));
  }

  void onLogoChanged(Uint8List bytes) {
    List<Uint8List> items = [];
    items.addAll(state.files);
    if (items.isEmpty){
      items.add(bytes);
    }else{
      items[0] = bytes;
    }
    emit(state.copyWith(files: items));
  }
}
