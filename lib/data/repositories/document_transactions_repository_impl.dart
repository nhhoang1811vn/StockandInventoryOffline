import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/document_transaction_repositories.dart';
import 'package:injectable/injectable.dart';

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
  Future<int> getSumQuantity() {
    // TODO: implement getSumQuantity
    throw UnimplementedError();
  }

  @override
  Future<int> getSumQuantityByGoodId(int goodId) {
    // TODO: implement getSumQuantityByGoodId
    throw UnimplementedError();
  }

  @override
  Future<List<DocumentTransaction>> getTransactions(int documentId) {
    return db.getTransactionsByDocumentId(documentId);
  }

  @override
  Future<int> insert(DocumentTransaction item) {
    return db.insertTransaction(item);
  }

  @override
  Future<bool> update(DocumentTransaction item) {
    return db.updateTransaction(item);
  }
}
