
import 'dart:async';

import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/repositories/payment_category_repositories.dart';
import 'package:good_manager/domain/usecases/payment_category/payment_category_usercases.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PaymentCategoryUseCases)
class PaymentCategoryUseCasesImp implements PaymentCategoryUseCases{
  final PaymentCategoryRepository repository;

  PaymentCategoryUseCasesImp({required this.repository});
  @override
  Future<int> insert(PaymentCategory item) {
    return repository.insert(item);
  }
  @override
  Future<bool> update(PaymentCategory item) {
    return repository.update(item);
  }

  @override
  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  @override
  Future<List<PaymentCategory>> getAll() {
    return repository.getAll();
  }
}