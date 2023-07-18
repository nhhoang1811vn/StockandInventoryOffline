import 'dart:async';

import 'package:good_manager/domain/entities/expense.dart';
import 'package:good_manager/domain/repositories/expense_repositories.dart';
import 'package:good_manager/domain/usecases/expenses/expense_usercases.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExpenseUseCases)
class ExpenseUseCasesImpl implements ExpenseUseCases{
  final ExpenseRepository repository;

  ExpenseUseCasesImpl({required this.repository});
  @override
  Future<int> insert(Expense item) {
    return repository.insert(item);
  }
  @override
  Future<bool> update(Expense item) {
    return repository.update(item);
  }

  @override
  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  @override
  Future<List<Expense>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }
  @override
  Future<double> getSum(int storeId) {
    return repository.getSum(storeId);
  }
}