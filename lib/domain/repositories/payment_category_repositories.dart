import 'package:good_manager/domain/repositories/base_repository.dart';

import '../entities/payment_category.dart';

abstract class PaymentCategoryRepository
    extends BaseRepository<PaymentCategory> {
  //Future<List<Payment>> getByDocumentId(int documentId);
  //Future<List<Payment>> getAllByStoreId(int storeId);
  //Future<List<Payment>> getInRange(DateTime start, DateTime end);
}
