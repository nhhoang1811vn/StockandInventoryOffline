import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/presentation/pages/save_document/sort/sort_transaction.dart';

class SortByCreatedDateDocumentTransaction extends SortTransaction {
  @override
  int getResult(DocumentTransaction item1, DocumentTransaction item2) {
    return item1.createdDate.compareTo(item2.createdDate);
  }
}


