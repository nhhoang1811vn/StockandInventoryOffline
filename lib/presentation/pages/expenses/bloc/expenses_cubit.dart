import 'package:good_manager/presentation/pages/base/base_cubit.dart';
import 'package:good_manager/presentation/pages/expenses/bloc/expenses_data.dart';
import 'package:good_manager/presentation/pages/help_content.dart';
import 'package:good_manager/domain/entities/expense.dart';

import '../../../../domain/entities/sort_by_text.dart';

class ExpensesCubit extends BaseCubit<ExpensesData> {
  ExpensesCubit(super.initialData);

  void initState(bool isSelection){
    //emit(state.copyWith());
  }
  void searchTextChanged(String value){
    emit(state.copyWith(textSearch: value));
  }
  void resetSearchText(){
    emit(state.copyWith(textSearch: ""));
  }
  void onShowSearchBarMenuClicked(){
    emit(state.copyWith(showSearchBar: !state.showSearchBar));
  }
  bool hasSortOptions() {
    return (state.settings.sortByName != SortByText.no_sort);
  }
  void onSortMenuClicked(){

  }
  void onHelpMenuClick(){

  }

  @override
  bool filterItem(Expense item, String textSearch) {
    return item.name.contains(textSearch);
  }

  @override
  Expense getEmptyItem() {
    return Expense();
  }

  @override
  String getSaveItemRouteName() {
    return "Pages.save_expense";
  }

  @override
  HelpType getHelpType() {
    return HelpType.EXPENSE;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
