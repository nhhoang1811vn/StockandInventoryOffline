import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/storage.dart';
import '../../../../domain/entities/expenses_setting.dart';
import '../../../../domain/entities/sort_by_text.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../base/base_state.dart';
part 'expenses_cubit.freezed.dart';
part 'expenses_state.dart';

@injectable
class ExpensesCubit extends Cubit<ExpensesState> {
  final Storage storage;
  ExpensesCubit({
    required this.storage
  }) : super(ExpensesState.initial(state: InitialState(), settings: storage.getExpensesSetting()));


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
}
