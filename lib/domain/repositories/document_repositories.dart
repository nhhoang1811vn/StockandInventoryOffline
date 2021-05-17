import 'package:good_manager/domain/entities/document.dart';

abstract class DocumentRepository {
  Future<List<Document>> findBySupplierId(int id);
}
