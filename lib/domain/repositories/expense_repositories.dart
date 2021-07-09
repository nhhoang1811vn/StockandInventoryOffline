import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/expenses_settings.dart';
import 'package:good_manager/domain/repositories/base_common_repository.dart';

abstract class ExpenseRepository
    extends BaseCommonRepository<Expense, ExpensesSettings> {}
