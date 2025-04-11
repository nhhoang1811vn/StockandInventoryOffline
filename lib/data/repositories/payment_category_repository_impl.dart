import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/payment_category_repositories.dart';

@Injectable(as: PaymentCategoryRepository)
class PaymentCategoryRepositoryImpl implements PaymentCategoryRepository {
  PaymentCategoryRepositoryImpl();

  var db = new DBHelper();
  @override
  Future<int> insert(PaymentCategory item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertPaymentCategory(item);
  }
  @override
  Future<bool> update(PaymentCategory item) {
    item.updatedDate = DateTime.now();
    return db.updatePaymentCategory(item);
  }

  @override
  Future<bool> delete(int id) {
    return db.deletePaymentCategory(id);
  }

  @override
  Future<PaymentCategory> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<PaymentCategory>> getAll() {
    return db.getAllPaymentCategory();
  }
}
