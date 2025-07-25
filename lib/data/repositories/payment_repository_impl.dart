import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/app_settings.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/repositories/payment_repositories.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  final AppSettings appSettings;
  PaymentRepositoryImpl(this.appSettings);

  var db = new DBHelper();
  @override
  Future<int> insert(Payment item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertPayment(item);
  }

  @override
  Future<bool> delete(int id) {
    return db.deletePayment(id);
  }

  @override
  Future<Payment> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<Payment>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  @override
  Future<List<Payment>> getAllByStoreId(int storeId) {
    return db.getPaymentByStoreId(storeId);
  }

  @override
  Future<bool> update(Payment item) {
    item.updatedDate = DateTime.now();
    return db.updatePayment(item);
  }

  @override
  Future<List<Payment>> getByDocumentId(int documentId) {
    return db.getPaymentByDocumentId(documentId);
  }
  @override
  Future<List<Payment>> getInRange(DateTime start, DateTime end) {
    int storeId = appSettings.getSelectedStoreId();
    return db.getPaymentsInRange(storeId, start, end);
  }

  @override
  Future<List<Payment>> getInRangeByWalletId(int walletId, DateTime start, DateTime end) {
    return db.getPaymentsInRangeByWalletId(walletId, start, end);
  }
  @override
  Future<List<Payment>> getInRangeBySupplierId(int supplierId, DateTime start, DateTime end) {
    return db.getPaymentsInRangeBySupplierId(supplierId, start, end);
  }
  @override
  Future<List<Payment>> getInRangeByCustomerId(int customerId, DateTime start, DateTime end) {
    return db.getPaymentsInRangeByCustomerId(customerId, start, end);
  }
}
