import 'package:good_manager/domain/entities/base_settings.dart';
import 'package:good_manager/domain/entities/search_documents_type.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';

class DocumentSettings extends BaseSettings {
  SortByNumber sortByDate;
  SortByNumber sortByQuantity;
  SearchDocumentsType searchDocumentsType;
}
