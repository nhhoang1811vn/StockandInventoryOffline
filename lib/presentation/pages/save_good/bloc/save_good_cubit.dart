import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/usecases/goods/goods_usercases.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/models/name.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/usecases/documents/document_usecases.dart';
import '../../../constants.dart';
import '../../base/base_state.dart';

part 'save_good_cubit.freezed.dart';
part 'save_good_state.dart';

@injectable
class SaveGoodCubit extends Cubit<SaveGoodState>{
  final GoodsUseCases useCase;
  final DocumentUseCases documentsUseCases;
  final Storage storage;
  SaveGoodCubit({required this.useCase, required this.documentsUseCases, required this.storage}) : super(SaveGoodState.initial(state: InitialState()));
  void init(Good item, Document? document,DocumentTransaction? transaction){
    SaveGoodState initState = state.copyWith(
        item: item,
        document: document,
        name: (item.name.isNotEmpty)?NameInput.dirty(value: item.name):NameInput.pure(),
        description: item.description,
        barCode: item.barCode??'',
        purchasePrice: item.purchasePrice,
        salePrice: item.salePrice,
        files: item.files,
        transaction: transaction
    );
    emit(initState);
  }
  void onSaveClicked() async {
    final validate = Formz.validate([state.name]);
    if (validate){
      try{
        Good item = state.item!;
        item.name = state.name.value;
        item.description = state.description;
        if (state.barCode.trim().isNotEmpty){
          item.barCode = state.barCode.trim();
        }
        if (state.transaction == null){
          item.purchasePrice = state.purchasePrice;
          item.salePrice = state.salePrice;
        }
        item.files = state.files;
        if (item.id == null){
          item.id = await useCase.insert(item);
        }else{
          await useCase.update(item);
        }
        //insert document and insert transaction
        if (state.document != null){
          //insert document
          Document document = state.document!;
          if (document.id == null){
            int documentId = await documentsUseCases.insert(document);
            document.id = documentId;
          }else{
            await documentsUseCases.update(document);
          }
          //insert transaction
          if (state.transaction!.id != null){
            await documentsUseCases.updateTransaction(state.transaction!);
          }else{
            DocumentTransaction transaction = state.transaction!;
            transaction.documentId = document.id!;
            transaction.goodId = item.id!;
            await documentsUseCases.insertTransaction(transaction);
          }
          emit(state.copyWith(state: SaveItemSuccessful(), document: document));
        }else{
          emit(state.copyWith(state: SaveItemSuccessful()));
        }
      }
      catch (e){
        if (e.toString().contains("UNIQUE constraint failed: Goods.barCode")){
          emit(state.copyWith(state: SaveItemSameBarcodeError()));
        }else{
          emit(state.copyWith(state: SaveItemError(e.toString())));
        }
      }
    }else{
      emit(state.copyWith(name: NameInput.dirty(value : state.name.value)));
    }
  }
  void nameChanged(String value){
    final name = NameInput.dirty(value: value);
    emit(state.copyWith(name: name));
  }
  void descriptionChanged(String value){
    emit(state.copyWith(description: value));
  }
  void barCodeChanged(String value){
    emit(state.copyWith(barCode: value));
  }
  void onImagesChanged(List<Uint8List> value){
    emit(state.copyWith(files: value));
  }
  void onQuantityCalculatorPressed(){
    emit(state.copyWith(state: OpenCalculatorToInputQuantityState()));
  }
  void onPriceCalculatorPressed(){
    emit(state.copyWith(state: OpenCalculatorToInputPriceState()));
  }
  void onPurchasePriceCalculatorPressed(){
    emit(state.copyWith(state: OpenCalculatorToInputPurchasePriceState()));
  }
  void onSalePriceCalculatorPressed(){
    emit(state.copyWith(state: OpenCalculatorToInputSalePriceState()));
  }
  void onBarcodeScannerPressed(){
    emit(state.copyWith(state: OpenBarcodeScannerPageState()));
  }

  void quantityChanged(String value) {
    if (value.isNotEmpty){
      DocumentTransaction current = state.transaction!;
      current.quantity = double.tryParse(value) ?? 0;
      emit(state.copyWith(transaction: current));
    }
  }
  void onPriceChanged(String value){
    DocumentTransaction current = state.transaction!;
    if (value.isNotEmpty){
      num numValue = Config.simpleCurrencyFormat.parse(value);
      double price = numValue.toDouble();
      current.price = price;
    }else{
      current.price = null;
    }
    emit(state.copyWith(transaction: current));
  }
  void onPurchasePriceChanged(String value){
    if (value.isNotEmpty){
      num numValue = Config.simpleCurrencyFormat.parse(value);
      double price = numValue.toDouble();
      emit(state.copyWith(purchasePrice: price));
    }else{
      emit(state.copyWith(purchasePrice: null));
    }
  }
  void onSalePriceChanged(String value){
    if (value.isNotEmpty){
      num numValue = Config.simpleCurrencyFormat.parse(value);
      double price = numValue.toDouble();
      emit(state.copyWith(salePrice: price));
    }else{
      emit(state.copyWith(salePrice: null));
    }
  }
}