import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/repositories/expense_repositories.dart';
import 'package:injectable/injectable.dart';

import '../../main.dart';

@Injectable(as: ExpenseRepository)
class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl();

  var db = new DBHelper();
  @override
  Future<int> insert(Expense item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertExpense(item);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteExpense(id);
  }

  @override
  Future<Expense> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  @override
  Future<List<Expense>> getAllByStoreId(int storeId) {
    return db.getExpenses(storeId);
  }

  @override
  Future<int> getCount() {
    // TODO: implement getCount
    throw UnimplementedError();
  }

  @override
  Future<bool> update(Expense item) {
    item.updatedDate = DateTime.now();
    return db.updateExpense(item);
  }

  @override
  Future<double> getSum(int storeId) {
    return db.getSumExpense(storeId);
  }
  @override
  Future<List<Expense>> getInRange(DateTime start, DateTime end) {
    int storeId = storage.getSelectedStoreId();
    return db.getExpensesInRange(storeId, start,end);
  }
}
