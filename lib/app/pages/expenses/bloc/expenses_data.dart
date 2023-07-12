import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:good_manager/app/pages/base/base_data.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/expenses_settings.dart';

import '../../base/base_state.dart';

part 'expenses_data.g.dart';

@CopyWith()
class ExpensesData extends BaseData{
  final List<Expense> items;
  final String textSearch;
  final ExpensesSettings settings;
  final bool showSearchBar;
  final bool isSelection;

  ExpensesData({BaseState? state,required this.items, required this.textSearch, required this.settings, required this.showSearchBar, required this.isSelection}) : super(state??InitialState());

}