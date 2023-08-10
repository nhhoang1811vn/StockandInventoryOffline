import 'package:good_manager/domain/entities/transaction.dart';

abstract class DocumentTransactionRepository {
  Future<int> insert(DocumentTransaction item);
  Future<bool> update(DocumentTransaction item);
  Future<List<DocumentTransaction>> getAll();
  Future<DocumentTransaction> get(int id);
  Future<bool> delete(int id);



  Future<void> deleteByDocumentId(int documentId);

  Future<void> deleteByGoodId(int goodId);

  Future<List<DocumentTransaction>> getTransactions(int documentId);

  Future<int> getSumQuantity();
  Future<int> getSumQuantityByGoodId(int goodId);
}
