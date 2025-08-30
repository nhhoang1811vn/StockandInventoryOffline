import 'package:injectable/injectable.dart';

import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../../usecase/base/items_usecases.dart';

@LazySingleton()
class PaymentUseCases extends ItemsUseCase<Payment> {
  final PaymentRepository repository;

  PaymentUseCases({required this.repository});

  Future<int> insert(Payment item) {
    return repository.insert(item);
  }

  Future<bool> update(Payment item) {
    return repository.update(item);
  }

  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  Future<List<Payment>> getAll() async {
    return List<Payment>.empty();
  }

  Future<List<Payment>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

  Future<List<Payment>> getByDocumentId(int documentId) {
    return repository.getByDocumentId(documentId);
  }

  Future<List<Payment>> getInRange(DateTime start, DateTime end) {
    return repository.getInRange(start, end);
  }

  Future<List<Payment>> getInRangeByWalletId(
    int walletId,
    DateTime start,
    DateTime end,
  ) {
    return repository.getInRangeByWalletId(walletId, start, end);
  }

  Future<List<Payment>> getInRangeBySupplierId(
    int supplierId,
    DateTime start,
    DateTime end,
  ) {
    return repository.getInRangeBySupplierId(supplierId, start, end);
  }

  Future<List<Payment>> getInRangeByCustomerId(
    int customerId,
    DateTime start,
    DateTime end,
  ) {
    return repository.getInRangeByCustomerId(customerId, start, end);
  }
}
