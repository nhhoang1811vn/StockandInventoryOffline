import 'package:good_manager/presentation/pages/save_document/sort/sort_transaction.dart';

import '../../../../domain/entity/entity.dart';

class SortByQuantityAscendingDocumentTransaction extends SortTransaction {
  @override
  int getResult(DocumentTransaction item1, DocumentTransaction item2) {
    return item1.quantity.compareTo(item2.quantity);
  }
}

class SortByQuantityDescendingDocumentTransaction extends SortTransaction {
  @override
  int getResult(DocumentTransaction item1, DocumentTransaction item2) {
    return item2.quantity.compareTo(item1.quantity);
  }
}
