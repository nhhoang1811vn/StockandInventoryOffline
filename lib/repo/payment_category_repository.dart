import 'package:injectable/injectable.dart';

import '../data/data.dart';
import '../domain/entity/entity.dart';

@LazySingleton()
class PaymentCategoryRepository {
  final DBHelper db;

  PaymentCategoryRepository({required this.db});

  Future<int> insert(PaymentCategory item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertPaymentCategory(item);
  }

  Future<bool> update(PaymentCategory item) {
    item.updatedDate = DateTime.now();
    return db.updatePaymentCategory(item);
  }

  Future<bool> delete(int id) {
    return db.deletePaymentCategory(id);
  }

  Future<List<PaymentCategory>> getAll() {
    return db.getAllPaymentCategory();
  }
}
