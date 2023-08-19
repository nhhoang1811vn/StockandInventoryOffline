import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/models/name.dart';
import '../../../constants.dart';

part 'save_expense_cubit.freezed.dart';
part 'save_expense_state.dart';

@injectable
class SaveExpenseCubit extends Cubit<SaveExpenseState> {
  final ExpenseUseCases useCase;

  SaveExpenseCubit({required this.useCase}) : super(SaveExpenseState.initial(state: InitialState()));

  void init(Expense item) {
    SaveExpenseState initState;
    if (item.id == null) {
      initState = state.copyWith(item: item, date: DateTime.now());
    } else {
      initState = state.copyWith(item: item,
          name: NameInput.dirty(value: item.name),
          description: item.description,
          amount: item.amount,
          date: item.date);
    }
    emit(initState);
  }
  void nameChanged(String value){
    final name = NameInput.dirty(value: value);
    emit(state.copyWith(name: name));
  }
  void descriptionChanged(String value){
    emit(state.copyWith(description: value));
  }
  void onAmountChanged(String value){
    if (value.isNotEmpty){
      num numValue = Config.simpleCurrencyFormat.parse(value);
      double amount = numValue.toDouble();
      emit(state.copyWith(amount: amount));
    }else{
      emit(state.copyWith(amount: 0));
    }
  }

  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }
  void onSaveClicked() async {
    final validate = Formz.validate([state.name]);
    if (validate){
      Expense item = state.item!;
      item.name = state.name.value;
      item.description = state.description;
      item.date = state.date!;
      item.amount = state.amount;
      if (item.id == null){
        await useCase.insert(item);
      }else{
        await useCase.update(item);
      }
      emit(state.copyWith(state: SaveItemSuccessful()));
    }else{
      emit(state.copyWith(name: NameInput.dirty(value : state.name.value)));
    }
  }
}