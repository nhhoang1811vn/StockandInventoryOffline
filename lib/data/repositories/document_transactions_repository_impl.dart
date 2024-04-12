import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/document.dart';

@Injectable(as: DocumentTransactionRepository)
class DocumentTransactionRepositoryImpl implements DocumentTransactionRepository {
  DocumentTransactionRepositoryImpl();

  var db = new DBHelper();

  @override
  Future<bool> delete(int id) {
    return db.deleteTransaction(id);
  }

  @override
  Future<void> deleteByDocumentId(int documentId) {
    // TODO: implement deleteByDocumentId
    throw UnimplementedError();
  }

  @override
  Future<void> deleteByGoodId(int goodId) {
    // TODO: implement deleteByGoodId
    throw UnimplementedError();
  }

  @override
  Future<DocumentTransaction> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<DocumentTransaction>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  @override
  Future<double> getSumQuantityByGoodIdAndByDocumentId(DocumentType type, int goodId, int documentId) {
    return db.getSumQuantityByGoodIdAndDocumentId(type, goodId, documentId);
  }
  @override
  Future<double> getSumQuantityByGoodId(DocumentType type, int goodId) {
    return db.getSumQuantityByGoodId(type, goodId);
  }

  @override
  Future<List<DocumentTransaction>> getTransactions(int documentId) {
    return db.getTransactionsByDocumentId(documentId);
  }

  @override
  Future<int> insert(DocumentTransaction item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertTransaction(item);
  }

  @override
  Future<bool> update(DocumentTransaction item) {
    item.updatedDate = DateTime.now();
    return db.updateTransaction(item);
  }
}
