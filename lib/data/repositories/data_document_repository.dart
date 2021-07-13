import 'package:good_manager/data/utils/constants.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/documents_settings.dart';
import 'package:good_manager/domain/entities/search_documents_type.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Future<List<Document>> getAll() {
    return db.getDocuments();
  }

  @override
  Future<int> getCount() {
    return db.getCountDocument();
  }

  @override
  Future<DocumentSettings> getSettings() async {
    var settings = DocumentSettings();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    settings.sortByName = SortByTextHelper.get(
        preferences.getInt(Constants.sortByNameDocumentKey));
    settings.sortByDate = SortByNumberHelper.get(
        preferences.getInt(Constants.sortByDateDocumentKey));
    settings.sortByQuantity = SortByNumberHelper.get(
        preferences.getInt(Constants.sortByQuantityDocumentKey));

    settings.searchDocumentsType = SearchDocumentsTypeHelper.get(
        preferences.getInt(Constants.searchDocumentsTypeKey));
    return settings;
  }

  @override
  Future<void> setSettings(DocumentSettings settings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(Constants.sortByNameDocumentKey,
        SortByTextHelper.getValue(settings.sortByName));
    preferences.setInt(Constants.sortByDateDocumentKey,
        SortByNumberHelper.getValue(settings.sortByDate));
    preferences.setInt(Constants.sortByQuantityDocumentKey,
        SortByNumberHelper.getValue(settings.sortByQuantity));

    preferences.setInt(Constants.searchDocumentsTypeKey,
        SearchDocumentsTypeHelper.getValue(settings.searchDocumentsType));
  }

  @override
  Future<Document> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }
}
