import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/transaction_repositories.dart';

class DataDocumentTransactionRepository
    implements DocumentTransactionRepository {
  //Singleton object of 'DataStoreRepository'
  static DataDocumentTransactionRepository _instance =
      DataDocumentTransactionRepository._internal();

  //Constructor
  DataDocumentTransactionRepository._internal();

  factory DataDocumentTransactionRepository() => _instance;

  var db = new DBHelper();

  @override
  Future<bool> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<DocumentTransaction>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<bool> insert(DocumentTransaction item) {
    return db.insertDocumentTransaction(item);
  }

  @override
  Future<bool> update(DocumentTransaction item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
