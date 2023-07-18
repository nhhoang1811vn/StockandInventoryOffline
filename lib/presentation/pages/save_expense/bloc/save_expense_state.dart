part of 'save_expense_cubit.dart';

@freezed
class SaveExpenseState with _$SaveExpenseState {
  const factory SaveExpenseState.initial({
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    DateTime? date,
    @Default(0) double amount,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default('') String exceptionError,
    Expense? item
  }) = _Initial;
}

