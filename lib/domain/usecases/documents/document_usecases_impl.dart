
import 'package:good_manager/domain/app_settings.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';
import 'package:good_manager/domain/usecases/documents/document_usecases.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/document_transaction_repositories.dart';

@Injectable(as: DocumentUseCases)
class DocumentUseCasesImpl implements DocumentUseCases{
  final AppSettings appSettings;
  final DocumentRepository repository;
  final DocumentTransactionRepository transactionRepository;

  DocumentUseCasesImpl({required this.appSettings,required this.repository, required this.transactionRepository});

  @override
  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  @override
  Future<List<Document>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<Document>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }
  @override
  Future<List<Document>> getInRange(DateTime start, DateTime end) {
    return repository.getInRange(start, end);
  }
  @override
  Future<List<Document>> getInRangeBySupplierId(int id, DateTime start, DateTime end) {
    return repository.getInRangeBySupplierId(id, start, end);
  }
  @override
  Future<List<Document>> getInRangeByCustomerId(int id, DateTime start, DateTime end) {
    return repository.getInRangeByCustomerId(id, start, end);
  }

  @override
  Future<int> insert(Document item) {
    int storeId = appSettings.getSelectedStoreId();
    appSettings.increaseAutoDocumentNo(storeId);
    return repository.insert(item);
  }

  @override
  Future<bool> update(Document item) {
    return repository.update(item);
  }
  @override
  Future<int> getCount(int storeId) {
    return repository.getCount(storeId);
  }
  @override
  Future<int> insertTransaction(DocumentTransaction item){
    return transactionRepository.insert(item);
  }
  @override
  Future<bool> updateTransaction(DocumentTransaction item) {
    return transactionRepository.update(item);
  }
  @override
  Future<bool> deleteTransaction(int transactionId) {
    return transactionRepository.delete(transactionId);
  }

  @override
  Future<List<DocumentTransaction>> getTransactionsByDocumentId(int documentId) {
    return transactionRepository.getTransactions(documentId);
  }

  @override
  Future<Document> get(int id) {
    return repository.get(id);
  }
}