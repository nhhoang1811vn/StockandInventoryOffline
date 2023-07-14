import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/presentation/pages/base/base_sort_items.dart';

class SortByDateAscendingDocument extends SortItems<Document> {
  @override
  int getResult(Document item1, Document item2) {
    return item1.date.compareTo(item2.date);
  }
}

class SortByDateDescendingDocument extends SortItems<Document> {
  @override
  int getResult(Document item1, Document item2) {
    return item2.date.compareTo(item1.date);
  }
}
