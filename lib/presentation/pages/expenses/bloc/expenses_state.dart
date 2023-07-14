part of 'expenses_cubit.dart';

@freezed
class ExpensesState with _$ExpensesState{
  const factory ExpensesState.initial({
    required BaseState state,
    @Default([]) List<Expense> items,
    @Default('') String textSearch,
    required ExpensesSetting settings,
    @Default(false) bool showSearchBar}) = _Initial;
}