import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class PaymentRepository
    extends BaseRepository<Payment> {
  Future<List<Payment>> getByDocumentId(int documentId);
  Future<List<Payment>> getAllByStoreId(int storeId);
  Future<List<Payment>> getInRange(DateTime start, DateTime end);
  Future<List<Payment>> getInRangeByWalletId(int walletId,DateTime start, DateTime end);
  Future<List<Payment>> getInRangeBySupplierId(int supplierId,DateTime start, DateTime end);
  Future<List<Payment>> getInRangeByCustomerId(int customerId,DateTime start, DateTime end);
}
