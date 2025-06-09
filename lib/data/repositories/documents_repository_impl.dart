import 'package:good_manager/data/storage.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/document.dart';


@Injectable(as: DocumentRepository)
class DocumentRepositoryImpl implements DocumentRepository {
  final Storage storage;
  DocumentRepositoryImpl(this.storage);

  var db = new DBHelper();
  @override
  Future<int> insert(Document item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertDocument(item);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteDocument(id);
  }

  @override
  Future<Document> get(int id) {
    return db.getDocument(id);
  }

  @override
  Future<List<Document>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  @override
  Future<List<Document>> getAllByStoreId(int storeId) {
    return db.getDocuments(storeId);
  }
  @override
  Future<List<Document>> getInRange(DateTime start, DateTime end) {
    int storeId = storage.getSelectedStoreId();
    return db.getDocumentsInRange(storeId, start, end);
  }

  @override
  Future<bool> update(Document item) {
    item.updatedDate = DateTime.now();
    return db.updateDocument(item);
  }

  @override
  Future<double> getSum() {
    // TODO: implement getSum
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteDocument(int id) {
    // TODO: implement deleteDocument
    throw UnimplementedError();
  }

  @override
  Future<int> insertDocument(Document document, List<DocumentTransaction> transactions) {
    // TODO: implement insertDocument
    throw UnimplementedError();
  }

  @override
  Future<bool> updateDocument(Document document, List<DocumentTransaction> transactions) {
    // TODO: implement updateDocument
    throw UnimplementedError();
  }

  @override
  Future<int> getCount(int storeId) {
    return db.getCountDocument(storeId);
  }
}
