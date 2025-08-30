import 'package:good_manager/presentation/pages/save_document/sort/sort_transaction.dart';

import '../../../../domain/entity/entity.dart';

class SortByBarCodeAscendingDocumentTransaction extends SortTransaction {
  @override
  int getResult(DocumentTransaction item1, DocumentTransaction item2) {
    if (item1.good.barCode == null && item2.good.barCode == null) {
      return 0;
    }
    if (item1.good.barCode == null) {
      return -1;
    }
    if (item2.good.barCode == null) {
      return 1;
    }
    return item1.good.barCode!.compareTo(item2.good.barCode!);
  }
}

class SortByBarCodeDescendingDocumentTransaction extends SortTransaction {
  @override
  int getResult(DocumentTransaction item1, DocumentTransaction item2) {
    if (item1.good.barCode == null && item2.good.barCode == null) {
      return 0;
    }
    if (item1.good.barCode == null) {
      return -1;
    }
    if (item2.good.barCode == null) {
      return 1;
    }
    return item2.good.barCode!.compareTo(item1.good.barCode!);
  }
}
