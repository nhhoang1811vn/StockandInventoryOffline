import 'package:injectable/injectable.dart';

import '../data/app_settings.dart';
import '../data/data.dart';
import '../domain/entity/entity.dart';

@LazySingleton()
class PaymentRepository {
  final DBHelper db;

  PaymentRepository({required this.db});

  Future<int> insert(Payment item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertPayment(item);
  }

  Future<bool> delete(int id) {
    return db.deletePayment(id);
  }

  Future<List<Payment>> getAllByStoreId(int storeId) {
    return db.getPaymentByStoreId(storeId);
  }

  Future<bool> update(Payment item) {
    item.updatedDate = DateTime.now();
    return db.updatePayment(item);
  }

  Future<List<Payment>> getByDocumentId(int documentId) {
    return db.getPaymentByDocumentId(documentId);
  }

  Future<List<Payment>> getInRange(DateTime start, DateTime end) {
    int storeId = AppSettings.getSelectedStoreId();
    return db.getPaymentsInRange(storeId, start, end);
  }

  Future<List<Payment>> getInRangeByWalletId(
    int walletId,
    DateTime start,
    DateTime end,
  ) {
    return db.getPaymentsInRangeByWalletId(walletId, start, end);
  }

  Future<List<Payment>> getInRangeBySupplierId(
    int supplierId,
    DateTime start,
    DateTime end,
  ) {
    return db.getPaymentsInRangeBySupplierId(supplierId, start, end);
  }

  Future<List<Payment>> getInRangeByCustomerId(
    int customerId,
    DateTime start,
    DateTime end,
  ) {
    return db.getPaymentsInRangeByCustomerId(customerId, start, end);
  }
}
