import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart';
import 'package:good_manager/domain/usecases/payment_category/payment_category_usercases.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/models/name.dart';
import '../../../../domain/entities/payment.dart';
import '../../../constants.dart';

part 'save_payment_cubit.freezed.dart';
part 'save_payment_state.dart';

@injectable
class SavePaymentCubit extends Cubit<SavePaymentState> {
  final PaymentUseCases useCase;
  final PaymentCategoryUseCases paymentCategoryUseCases;
  SavePaymentCubit({required this.useCase, required this.paymentCategoryUseCases}) : super(SavePaymentState.initial(state: InitialState()));
  void init(Payment item) async{
    var allCategories = await paymentCategoryUseCases.getAll();
    var categories = allCategories.where((category) => category.type == item.type).toList();
    /*emit(state.copyWith(categories: categories));
    SavePaymentState initState;
    if (item.id == null) {
      initState = state.copyWith(item: item, date: DateTime.now());
    } else {
      initState = state.copyWith(item: item,
          description: item.description,
          documentId: item.documentId,
          documentName: NameInput.dirty(value: item.documentName??""),
          amount: item.amount,
          date: item.date
      );
    }
    emit(initState);*/
    //PaymentCategory? selectedCategory = categories.firstWhere((category) => category.id == item.categoryId,  orElse: () => null as PaymentCategory?);
    PaymentCategory? selectedCategory = categories.firstWhereOrNull(
          (category) => category.id == item.categoryId,
    );
    emit(state.copyWith(
      state: UpdateItemState(),
      categories: categories,
      selectedCategory: selectedCategory,
      item: item,
        description: item.description,
        documentId: item.documentId,
        documentName: NameInput.dirty(value: item.documentName??""),
        amount: item.amount,
        date: item.date
    ));
  }
  void descriptionChanged(String value){
    emit(state.copyWith(description: value));
  }
  void onDocumentChanged(Document item){
    emit(state.copyWith(state: InitialState(),
        documentName: NameInput.dirty(value: item.name),
        documentId: item.id
    ));
  }
  void onDocumentNameClicked(){
    emit(state.copyWith(state: OpenDocumentListState()));
  }
  void onAmountChanged(String value){
    if (value.isNotEmpty){
      num amountNum = Config.currencyFormat.parse(value);
      double amount = amountNum.toDouble();
      emit(state.copyWith(amount: amount));
    }else{
      emit(state.copyWith(amount: null));
    }
  }

  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }
  void onSaveClicked() async {
      Payment item = state.item!;
      item.description = state.description;
      item.date = state.date!;
      item.amount = state.amount;
      item.documentId = state.documentId;
      item.categoryId = state.selectedCategory?.id;

      if (item.id == null){
        await useCase.insert(item);
      }else{
        await useCase.update(item);
      }
      emit(state.copyWith(state: SaveItemSuccessful()));
  }
  void resetState() {
    emit(state.copyWith(state: InitialState()));
  }

  void onCategoryChanged(PaymentCategory item){
    emit(state.copyWith(state: UpdateItemState(),selectedCategory: item));
  }
  void onRefreshCategories() async{
    var allCategories = await paymentCategoryUseCases.getAll();
    var categories = allCategories.where((category) => category.type == state.item!.type).toList();

    PaymentCategory? selectedCategory = categories.firstWhereOrNull(
          (category) => category.id == state.selectedCategory?.id,
    );
    emit(state.copyWith(categories: categories, selectedCategory: selectedCategory));
  }
  void deleteCategory(int id) async{
    await paymentCategoryUseCases.delete(id);
  }
}