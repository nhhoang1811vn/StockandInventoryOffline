import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/usecases/base/items_usecases.dart';

abstract class PaymentUseCases extends ItemsUseCase<Payment>{
  Future<List<Payment>> getByDocumentId(int documentId);
  Future<List<Payment>> getAllByStoreId(int storeId);
  Future<List<Payment>> getInRange(DateTime start, DateTime end);
  Future<List<Payment>> getInRangeByWalletId(int walletId, DateTime start, DateTime end);
  Future<List<Payment>> getInRangeBySupplierId(int supplierId, DateTime start, DateTime end);
  Future<List<Payment>> getInRangeByCustomerId(int customerId, DateTime start, DateTime end);


}