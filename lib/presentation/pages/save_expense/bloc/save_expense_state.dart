part of 'save_expense_cubit.dart';

@freezed
class SaveExpenseState with _$SaveExpenseState {
  const factory SaveExpenseState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    DateTime? date,
    double? amount,
    @Default('') String exceptionError,
    Expense? item
  }) = _Initial;
}

