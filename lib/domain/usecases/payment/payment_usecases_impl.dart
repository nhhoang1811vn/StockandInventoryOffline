
import 'dart:async';

import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/repositories/payment_repositories.dart';
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PaymentUseCases)
class PaymentUseCasesImpl implements PaymentUseCases{
  final PaymentRepository repository;

  PaymentUseCasesImpl({required this.repository});
  @override
  Future<int> insert(Payment item) {
    return repository.insert(item);
  }
  @override
  Future<bool> update(Payment item) {
    return repository.update(item);
  }

  @override
  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  @override
  Future<List<Payment>> getAll() {
    return repository.getAll();
  }
  @override
  Future<List<Payment>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }
  @override
  Future<List<Payment>> getByDocumentId(int documentId) {
    return repository.getByDocumentId(documentId);
  }
  @override
  Future<List<Payment>> getInRange(DateTime start, DateTime end) {
    return repository.getInRange(start,end);
  }
  @override
  Future<List<Payment>> getInRangeByWalletId(int walletId, DateTime start, DateTime end) {
    return repository.getInRangeByWalletId(walletId,start,end);
  }
  @override
  Future<List<Payment>> getInRangeBySupplierId(int supplierId, DateTime start, DateTime end) {
    return repository.getInRangeBySupplierId(supplierId, start, end);
  }
  @override
  Future<List<Payment>> getInRangeByCustomerId(int customerId, DateTime start, DateTime end) {
    return repository.getInRangeByCustomerId(customerId, start, end);
  }

  @override
  Future<Payment> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

}