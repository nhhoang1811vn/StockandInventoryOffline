import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecases/documents/document_usecases.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/document.dart';
import '../../../../domain/entities/models/name.dart';
import '../../../../domain/entities/transaction.dart';

part 'save_document_cubit.freezed.dart';
part 'save_document_state.dart';

@injectable
class SaveDocumentCubit extends Cubit<SaveDocumentState> {
  final DocumentUseCases useCase;
  SaveDocumentCubit({required this.useCase}) : super(SaveDocumentState.initial(state: InitialState()));

  void init(Document item){
      SaveDocumentState initState = state.copyWith(item: item,
          id: item.id,
          name: NameInput.dirty(value: item.name),
          description: item.description,
          date: item.date,
          personId: item.personId,
          personName: item.personName
      );
      emit(initState);
      if (item.id != -1){
        loadTransactions();
      }
  }

  Future<bool> onWillPop() async {
    return true;
  }
  void nameChanged(String value){
    final name = NameInput.dirty(value: value);
    emit(state.copyWith(name: name));
  }
  void descriptionChanged(String value){
    emit(state.copyWith(description: value));
  }
  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }
  Future<bool> save() async{
    final validate = Formz.validate([state.name]);
    if (validate){
      Document item = state.item!;
      item.name = state.name.value;
      item.description = state.description;
      item.date = state.date!;
      item.personId = state.personId;
      if (state.id == -1){
        int id = await useCase.insert(item);
        emit(state.copyWith(id: id));
      }else{
        item.id = state.id;
        await useCase.update(item);
      }
      emit(state.copyWith(item: item));
      return true;
    }else{
      emit(state.copyWith(name: NameInput.dirty(value : state.name.value)));
      return false;
    }
  }
  void onAddGoodClicked() async{
    bool result = await save();
    if (result){
      emit(state.copyWith(state: OpenGoodListState()));
    }
  }
  void onSaveMenuClicked() async{
    bool result = await save();
    if (result){
      emit(state.copyWith(state: SaveDocumentSuccessfulState(state.item!)));
    }
  }
  void onSearchMenuClicked() {

  }

  onPersonClicked() {
    emit(state.copyWith(state: OpenPersonListState()));
  }
  void onPersonChanged(int id){
    emit(state.copyWith(personId: id));
  }

  void loadTransactions() async {
    List<DocumentTransaction> transactions = await useCase.getTransactionsByDocumentId(state.id);
    emit(state.copyWith(transactions: transactions));
  }
  void deleteTransaction(DocumentTransaction item) async{
    bool result = await useCase.deleteTransaction(item.id);
    if (result){
      loadTransactions();
    }
  }

  void onPressedTransaction(DocumentTransaction transaction) {
    emit(state.copyWith(state: OpenSaveGoodState(transaction)));
  }

  void updateTransaction(DocumentTransaction transaction) async {
    final result = await useCase.updateTransaction(transaction);
  }
}
