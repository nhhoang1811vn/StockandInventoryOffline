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
}
