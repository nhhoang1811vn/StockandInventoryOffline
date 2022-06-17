import 'package:good_manager/data/utils/constants.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/entities/expenses_settings.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/domain/repositories/expense_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataExpenseRepository implements ExpenseRepository {
  //Singleton object of 'DataStoreRepository'
  static DataExpenseRepository _instance = DataExpenseRepository._internal();

  //Constructor
  DataExpenseRepository._internal();

  factory DataExpenseRepository() => _instance;

  var db = new DBHelper();

  @override
  Future<List<Expense>> getAll() {
    return db.getExpenses();
  }

  @override
  Future<int> insert(Expense item) {
    return db.insertExpense(item);
  }

  @override
  Future<bool> update(Expense item) {
    return db.updateExpense(item);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteExpense(id);
  }

  @override
  Future<ExpensesSettings> getSettings() async {
    var settings = ExpensesSettings();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    settings.sortByName = SortByTextHelper.get(
        preferences.getInt(Constants.sortByNameExpensesKey));
    return settings;
  }

  @override
  Future<void> setSettings(ExpensesSettings settings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(Constants.sortByNameExpensesKey,
        SortByTextHelper.getValue(settings.sortByName));
  }

  @override
  Future<int> getCount() {
    // TODO: implement getCount
    throw UnimplementedError();
  }

  @override
  Future<double> getSum() {
    return db.getSumExpense();
  }

  @override
  Future<Expense> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }
}
