import 'package:injectable/injectable.dart';

import '../../../data/app_settings.dart';
import '../../../presentation/pages/base/base_sort_items.dart';
import '../../../presentation/pages/documents/sort/sort_by_date_documents.dart';
import '../../../repo/repo.dart';
import '../../entity/entity.dart';

@LazySingleton()
class GoodHistoryUseCases {
  final DocumentRepository documentRepository;
  final DocumentTransactionRepository documentTransactionRepository;

  GoodHistoryUseCases({
    required this.documentRepository,
    required this.documentTransactionRepository,
  });

  Future<List<GoodHistory>> getAll(int goodId) async {
    int storeId = AppSettings.getSelectedStoreId();
    var documents = await documentRepository.getAllByStoreId(storeId);
    var sortedDocuments = sortDocuments(documents);
    return getData(sortedDocuments, goodId);
  }

  Future<List<GoodHistory>> getInRange(
    int goodId,
    DateTime start,
    DateTime end,
  ) async {
    var documents = await documentRepository.getInRange(start, end);
    var sortedDocuments = sortDocuments(documents);
    return getData(sortedDocuments, goodId);
  }

  List<Document> sortDocuments(List<Document> items) {
    List<SortItems> options = [];
    options.add(SortByDateDescendingDocument());
    List<Document> newItems = [];
    newItems.addAll(items);
    newItems.sort((item1, item2) {
      int compare = 0;
      for (final option in options) {
        compare = option.getResult(item1, item2);
        if (compare != 0) break;
      }
      return compare;
    });
    return newItems;
  }

  Future<List<GoodHistory>> getData(
    List<Document> documents,
    int goodId,
  ) async {
    List<GoodHistory> results = [];
    for (Document document in documents) {
      int documentId = document.id!;
      var transactions = await documentTransactionRepository
          .getTransactionsByDocumentIdAndGoodId(documentId, goodId);
      var quantity = 0.0;
      var amount = 0.0;
      for (DocumentTransaction transaction in transactions) {
        quantity += transaction.quantity;
        if (transaction.price != null) {
          amount += transaction.quantity * transaction.price!;
        }
      }
      if (transactions.isNotEmpty) {
        results.add(GoodHistory(document, quantity, amount));
      }
    }
    return results;
  }
}
