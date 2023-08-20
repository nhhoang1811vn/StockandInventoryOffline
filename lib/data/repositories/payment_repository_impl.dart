import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/repositories/payment_repositories.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl();

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
  Future<bool> update(Payment item) {
    item.updatedDate = DateTime.now();
    return db.updatePayment(item);
  }

  @override
  Future<List<Payment>> getByDocumentId(int documentId) {
    return db.getPaymentByDocumentId(documentId);
  }
}
