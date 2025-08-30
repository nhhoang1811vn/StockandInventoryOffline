import 'package:injectable/injectable.dart';

import '../data/app_settings.dart';
import '../data/data.dart';
import '../domain/entity/entity.dart';

@LazySingleton()
class DocumentRepository {
  final DBHelper db;

  DocumentRepository({required this.db});

  Future<int> insert(Document item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertDocument(item);
  }

  Future<bool> delete(int id) {
    return db.deleteDocument(id);
  }

  Future<Document> get(int id) {
    return db.getDocument(id);
  }

  Future<List<Document>> getAllByStoreId(int storeId) {
    return db.getDocuments(storeId);
  }

  Future<List<Document>> getInRange(DateTime start, DateTime end) {
    int storeId = AppSettings.getSelectedStoreId();
    return db.getDocumentsInRange(storeId, start, end);
  }

  Future<bool> update(Document item) {
    item.updatedDate = DateTime.now();
    return db.updateDocument(item);
  }

  Future<int> getCount(int storeId) {
    return db.getCountDocument(storeId);
  }

  Future<List<Document>> getInRangeByCustomerId(
    int id,
    DateTime start,
    DateTime end,
  ) {
    int storeId = AppSettings.getSelectedStoreId();
    return db.getDocumentsInRangeByCustomerId(storeId, id, start, end);
  }

  Future<List<Document>> getInRangeBySupplierId(
    int id,
    DateTime start,
    DateTime end,
  ) {
    int storeId = AppSettings.getSelectedStoreId();
    return db.getDocumentsInRangeBySupplierId(storeId, id, start, end);
  }
}
