import 'package:injectable/injectable.dart';

import '../../../data/app_settings.dart';
import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../base/items_usecases.dart';

@LazySingleton()
class DocumentUseCases extends ItemsUseCase<Document> {
  final DocumentRepository repository;
  final DocumentTransactionRepository transactionRepository;

  DocumentUseCases({
    required this.repository,
    required this.transactionRepository,
  });

  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  Future<List<Document>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

  Future<List<Document>> getInRange(DateTime start, DateTime end) {
    return repository.getInRange(start, end);
  }

  Future<List<Document>> getInRangeBySupplierId(
    int id,
    DateTime start,
    DateTime end,
  ) {
    return repository.getInRangeBySupplierId(id, start, end);
  }

  Future<List<Document>> getInRangeByCustomerId(
    int id,
    DateTime start,
    DateTime end,
  ) {
    return repository.getInRangeByCustomerId(id, start, end);
  }

  Future<int> insert(Document item) {
    int storeId = AppSettings.getSelectedStoreId();
    AppSettings.increaseAutoDocumentNo(storeId);
    return repository.insert(item);
  }

  Future<bool> update(Document item) {
    return repository.update(item);
  }

  Future<int> getCount(int storeId) {
    return repository.getCount(storeId);
  }

  Future<int> insertTransaction(DocumentTransaction item) {
    return transactionRepository.insert(item);
  }

  Future<bool> updateTransaction(DocumentTransaction item) {
    return transactionRepository.update(item);
  }

  Future<bool> deleteTransaction(int transactionId) {
    return transactionRepository.delete(transactionId);
  }

  Future<List<DocumentTransaction>> getTransactionsByDocumentId(
    int documentId,
  ) {
    return transactionRepository.getTransactions(documentId);
  }

  Future<Document> get(int id) {
    return repository.get(id);
  }
}
