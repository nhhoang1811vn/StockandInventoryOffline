import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/presentation/pages/base/base_sort_items.dart';

class SortByDateExpenseAsc extends SortItems<Expense>{
  @override
  int getResult(Expense item1, Expense item2) {
    return item1.date.compareTo(item2.date);
  }
}
class SortByDateExpenseDesc extends SortItems<Expense>{
  @override
  int getResult(Expense item1, Expense item2) {
    return item2.date.compareTo(item1.date);
  }
}