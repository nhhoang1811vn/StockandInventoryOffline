import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class DocumentRepository
    extends BaseRepository<Document> {
  Future<int> insertDocument(Document document, List<DocumentTransaction> transactions);
  Future<bool> updateDocument(Document document, List<DocumentTransaction> transactions);
  Future<bool> deleteDocument(int id);
  Future<int> getCount(int storeId);

  Future<List<Document>> getAllByStoreId(int storeId);
  Future<List<Document>> getInRange(DateTime start, DateTime end);
  Future<List<Document>> getInRangeBySupplierId(int id, DateTime start, DateTime end);
  Future<List<Document>> getInRangeByCustomerId(int id, DateTime start, DateTime end);
}
