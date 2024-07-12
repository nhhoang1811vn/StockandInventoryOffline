import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/usecases/base/items_usecases.dart';

abstract class DocumentUseCases extends ItemsUseCase<Document>{
  Future<List<Document>> getAllByStoreId(int storeId);
  Future<int> getCount(int storeId);
  Future<int> insertTransaction(DocumentTransaction item);
  Future<bool> updateTransaction(DocumentTransaction item);
  Future<List<DocumentTransaction>> getTransactionsByDocumentId(int documentId);
  Future<bool> deleteTransaction(int transactionId);

  Future<List<Document>> getInRange(DateTime start, DateTime end);
}