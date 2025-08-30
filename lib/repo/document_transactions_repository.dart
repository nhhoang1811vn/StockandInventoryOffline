import 'package:injectable/injectable.dart';

import '../data/data.dart';
import '../domain/entity/entity.dart';

@LazySingleton()
class DocumentTransactionRepository {
  final DBHelper db;

  DocumentTransactionRepository({required this.db});

  Future<bool> delete(int id) {
    return db.deleteTransaction(id);
  }

  Future<double> getSumQuantityByGoodIdAndByDocumentId(
    DocumentType type,
    int goodId,
    int documentId,
  ) {
    return db.getSumQuantityByGoodIdAndDocumentId(type, goodId, documentId);
  }

  Future<double> getSumQuantityByGoodId(DocumentType type, int goodId) {
    return db.getSumQuantityByGoodId(type, goodId);
  }

  Future<List<DocumentTransaction>> getTransactions(int documentId) {
    return db.getTransactionsByDocumentId(documentId);
  }

  Future<List<DocumentTransaction>> getTransactionsByDocumentIdAndGoodId(
    int documentId,
    int goodId,
  ) {
    return db.getTransactionsByDocumentIdAndGoodId(documentId, goodId);
  }

  Future<int> insert(DocumentTransaction item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertTransaction(item);
  }

  Future<bool> update(DocumentTransaction item) {
    item.updatedDate = DateTime.now();
    return db.updateTransaction(item);
  }
}
