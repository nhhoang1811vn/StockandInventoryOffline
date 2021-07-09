import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/transaction_repositories.dart';

class DataDocumentTransactionRepository
    implements DocumentTransactionRepository {
  static DataDocumentTransactionRepository _instance =
      DataDocumentTransactionRepository._internal();

  //Constructor
  DataDocumentTransactionRepository._internal();

  factory DataDocumentTransactionRepository() => _instance;

  var db = new DBHelper();

  @override
  Future<bool> delete(int id) {
    return db.deleteTransaction(id);
  }

  @override
  Future<List<DocumentTransaction>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<int> insert(DocumentTransaction item) {
    return db.insertTransaction(item);
  }

  @override
  Future<bool> update(DocumentTransaction item) {
    return db.updateTransaction(item);
  }

  @override
  Future<void> deleteByDocumentId(int documentId) {
    return db.deleteTransactionByDocumentId(documentId);
  }

  @override
  Future<void> deleteByGoodId(int goodId) {
    return db.deleteTransactionByGoodId(goodId);
  }

  @override
  Future<List<DocumentTransaction>> getTransactions(int documentId) {
    return db.getTransactionsByDocumentId(documentId);
  }
}
