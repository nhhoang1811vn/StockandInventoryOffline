import 'package:good_manager/presentation/pages/save_document/sort/sort_transaction.dart';

import '../../../../domain/entity/entity.dart';

class SortByNameAToZDocumentTransaction extends SortTransaction {
  @override
  int getResult(DocumentTransaction item1, DocumentTransaction item2) {
    return item1.good.name.compareTo(item2.good.name);
  }
}

class SortByNameZToADocumentTransaction extends SortTransaction {
  @override
  int getResult(DocumentTransaction item1, DocumentTransaction item2) {
    return item2.good.name.compareTo(item1.good.name);
  }
}
