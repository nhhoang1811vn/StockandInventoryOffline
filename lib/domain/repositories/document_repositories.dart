import 'package:good_manager/domain/entities/document.dart';

import 'base_repository.dart';

abstract class DocumentRepository extends BaseRepository<Document> {
  Future<List<Document>> getDocuments(int storeId);
}
