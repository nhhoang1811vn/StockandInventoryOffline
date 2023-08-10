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
import '../../base/base_state.dart';

part 'save_good_cubit.freezed.dart';
part 'save_good_state.dart';

@injectable
class SaveGoodCubit extends Cubit<SaveGoodState>{
  final GoodsUseCases useCase;
  final DocumentUseCases documentsUseCases;
  final Storage storage;
  SaveGoodCubit({required this.useCase, required this.documentsUseCases, required this.storage}) : super(SaveGoodState.initial(state: InitialState()));
  void init(Good item, Document? document,DocumentTransaction? transaction, int? quantity){
    SaveGoodState initState = state.copyWith(
        item: item,
        document: document,
        name: (item.name.isNotEmpty)?NameInput.dirty(value: item.name):NameInput.pure(),
        description: item.description,
        barCode: item.barCode??'',
        files: item.files,
        transaction: transaction,
        quantity: quantity
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
        item.files = state.files;
        if (item.id == null){
          item.id = await useCase.insert(item);
        }else{
          await useCase.update(item);
        }
        //insert document and insert transaction
        if (state.quantity != null && state.document != null){
          //insert document
          Document document = state.document!;
          if (document.id == null){
            int documentId = await documentsUseCases.insert(document);
            document.id = documentId;
          }else{
            await documentsUseCases.update(document);
          }
          //insert transaction
          if (state.transaction != null){
            //update
            DocumentTransaction transaction = state.transaction!;
            transaction.quantity = state.quantity!;
            await documentsUseCases.updateTransaction(state.transaction!);
          }else{
            //insert
            DocumentTransaction transaction = DocumentTransaction();
            transaction.documentId = document.id!;
            transaction.goodId = item.id!;
            transaction.quantity = state.quantity!;
            transaction.type = state.document!.type;
            transaction.storeId = storage.getSelectedStoreId();

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
  void onImagesChanged(List<String> value){
    emit(state.copyWith(files: value));
  }
  void onModifyQuantityButtonPressed(){
    emit(state.copyWith(state: OpenCalculatorToInputQuantityState()));
  }
  void onBarcodeScannerPressed(){
    emit(state.copyWith(state: OpenBarcodeScannerPageState()));
  }

  void quantityChanged(String value) {
    emit(state.copyWith(quantity: int.parse(value)));
  }
}