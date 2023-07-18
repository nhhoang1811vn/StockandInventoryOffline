import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/presentation/pages/expenses/sort/sort_by_date_expense.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/expenses_setting.dart';
import '../../../../domain/usecases/expenses/expense_usercases.dart';
import '../../base/base_sort_items.dart';
import '../../base/base_state.dart';

part 'expenses_cubit.freezed.dart';
part 'expenses_state.dart';

@injectable
class ExpensesCubit extends Cubit<ExpensesState> {
  final Storage storage;
  final ExpenseUseCases useCase;
  ExpensesCubit({
    required this.storage,
    required this.useCase
  }) : super(ExpensesState.initial(state: InitialState(), settings: storage.getExpensesSetting()));
  void init(){
    loadItems();
  }

  void searchTextChanged(String value){
    emit(state.copyWith(textSearch: value));
    filter();
    sort();
  }
  void resetSearchText(){
    emit(state.copyWith(textSearch: ""));
    filter();
    sort();
  }
  void onShowSearchBarMenuClicked(){
    emit(state.copyWith(showSearchBar: !state.showSearchBar));
    resetSearchText();
  }
  bool hasSortOptions() {
    return (state.settings.sortByDate != SortByNumber.no_sort);
  }
  void onSortMenuClicked(){
    emit(state.copyWith(state: OpenSortDialogListState()));
  }
  void onHelpMenuClick(){
    emit(state.copyWith(state: OpenHelpPageState()));
  }
  void onAddItem() {
    Expense item = Expense();
    item.storeId = storage.getSelectedStoreId();
    emit(state.copyWith(state: SaveExpenseState(item)));
  }
  void loadItems() async{
    final storeId = storage.getSelectedStoreId();
    List<Expense> allItems = await useCase.getAllByStoreId(storeId);
    emit(state.copyWith(allItems: allItems));
    filter();
    sort();
  }
  void filter(){
    List<Expense> items = state.allItems.where((element) => filterExpense(element)).toList();
    emit(state.copyWith(items: items));
  }
  bool filterExpense(Expense item) {
    if (state.textSearch.trim().isEmpty) {
      return true;
    }
    return item.name.contains(state.textSearch);
  }
  void sort(){
    List<Expense> items = sortExpense();
    emit(state.copyWith(items: items));
  }
  List<Expense> sortExpense(){
    List<SortItems<Expense>> options = [];
    switch (state.settings.sortByDate) {
      case SortByNumber.ascending:
        {
          options.add(SortByDateExpenseAsc());
          break;
        }
      case SortByNumber.descending:
        {
          options.add(SortByDateExpenseDesc());
          break;
        }
      default:
        {}
    }
    if (options.isEmpty) {
      options.add(SortByCreatedDate());
    }
    List<Expense> items = [];
    items.addAll(state.items);
    items.sort((item1, item2) {
      int compare = 0;
      for (final option in options) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
    return items;
  }
  void setSettings(ExpensesSetting settings) {
    storage.setExpensesSetting(settings);
    emit(state.copyWith(settings: settings));
    sort();
  }
  delete(int id) async{
    await useCase.delete(id);
    loadItems();
  }
}
