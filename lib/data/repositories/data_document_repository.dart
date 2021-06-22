import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';

class DataDocumentRepository implements DocumentRepository {
  //Singleton object of 'DataStoreRepository'
  static DataDocumentRepository _instance = DataDocumentRepository._internal();

  //Constructor
  DataDocumentRepository._internal() {}

  factory DataDocumentRepository() => _instance;

  var db = new DBHelper();

  @override
  Future<List<Document>> findBySupplierId(int id) {
    return db.findDocumentBySupplierId(id);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteDocument(id);
  }

  @override
  Future<int> insert(Document item) {
    return db.insertDocument(item);
  }

  @override
  Future<bool> update(Document item) {
    return db.updateDocument(item);
  }

  /*@override
  Future<List<Document>> getDocumentsByType(DocumentType type) {
    return db.getDocumentsByType(type);
  }*/

  @override
  Future<List<Document>> getDocuments(int storeId) {
    return db.getDocuments(storeId);
  }

  @override
  Future<List<Document>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
}
