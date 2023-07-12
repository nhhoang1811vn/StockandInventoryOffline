import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class ExpenseRepository
    extends BaseRepository<Expense> {
  Future<double> getSum();
}
