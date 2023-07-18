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
}
