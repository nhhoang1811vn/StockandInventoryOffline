import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/document.dart';
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

  @override
  Future<int> getCount() {
    // TODO: implement getCount
    throw UnimplementedError();
  }

  @override
  Future<int> getSumQuantity() async {
    int incomingQuantity = await db.getSumQuantity(DocumentType.incoming);
    int outgoingQuantity = await db.getSumQuantity(DocumentType.outgoing);
    return (incomingQuantity - outgoingQuantity);
  }
  @override
  Future<int> getSumQuantityByGoodId(int goodId) async {
    int incomingQuantity = await db.getSumQuantityByGoodId(DocumentType.incoming, goodId);
    int outgoingQuantity = await db.getSumQuantityByGoodId(DocumentType.outgoing, goodId);
    return (incomingQuantity - outgoingQuantity);
  }

  @override
  Future<DocumentTransaction> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }
}
