import 'package:good_manager/presentation/pages/base/base_sort_items.dart';
import 'package:good_manager/domain/entities/document.dart';

class SortByQuantityAscendingDocument extends SortItems<Document> {
  @override
  int getResult(Document item1, Document item2) {
    return item1.quantity.compareTo(item2.quantity);
  }
}

class SortByQuantityDescendingDocument extends SortItems<Document> {
  @override
  int getResult(Document item1, Document item2) {
    return item2.quantity.compareTo(item1.quantity);
  }
}
