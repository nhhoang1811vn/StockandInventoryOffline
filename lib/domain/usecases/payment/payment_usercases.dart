import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/usecases/base/items_usecases.dart';

abstract class PaymentUseCases extends ItemsUseCase<Payment>{
  Future<List<Payment>> getByDocumentId(int documentId);
  Future<List<Payment>> getAllByStoreId(int storeId);

}