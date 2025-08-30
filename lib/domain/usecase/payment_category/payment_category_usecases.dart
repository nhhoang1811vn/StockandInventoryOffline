import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../repo/repo.dart';
import '../../entity/entity.dart';

@LazySingleton()
class PaymentCategoryUseCases {
  final PaymentCategoryRepository repository;

  PaymentCategoryUseCases({required this.repository});

  Future<int> insert(PaymentCategory item) {
    return repository.insert(item);
  }

  Future<bool> update(PaymentCategory item) {
    return repository.update(item);
  }

  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  Future<List<PaymentCategory>> getAll() {
    return repository.getAll();
  }
}
