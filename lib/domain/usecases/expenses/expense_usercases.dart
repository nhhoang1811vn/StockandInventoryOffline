import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/usecases/base/items_usecases.dart';

abstract class ExpenseUseCases extends ItemsUseCase<Expense>{
  Future<List<Expense>> getAllByStoreId(int storeId);
  Future<double> getSum(int storeId);

  Future<List<Expense>> getExpensesInRange(DateTime start, DateTime end);
}