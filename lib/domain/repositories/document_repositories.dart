import 'package:good_manager/domain/entities/Document.dart';

abstract class DocumentRepository {
  Future<List<Document>> findBySupplierId(int id);
}
