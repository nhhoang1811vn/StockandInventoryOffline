import 'dart:async';

import 'package:good_manager/domain/app_settings.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good_history.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';
import 'package:good_manager/domain/usecases/goods/goods_history_usecases.dart';
import 'package:good_manager/presentation/pages/base/base_sort_items.dart';
import 'package:good_manager/presentation/pages/documents/sort/sort_by_date_documents.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/document_transaction_repositories.dart';

@Injectable(as: GoodHistoryUseCases)
class GoodHistoryUseCasesIpm implements GoodHistoryUseCases{
  final AppSettings appSettings;
  final DocumentRepository documentRepository;
  final DocumentTransactionRepository documentTransactionRepository;
  GoodHistoryUseCasesIpm({required this.appSettings,required this.documentRepository, required this.documentTransactionRepository});

  @override
  Future<List<GoodHistory>> getAll(int goodId) async{
    int storeId = appSettings.getSelectedStoreId();
    var documents = await documentRepository.getAllByStoreId(storeId);
    var sortedDocuments = sortDocuments(documents);
    return getData(sortedDocuments, goodId);
  }

  @override
  Future<List<GoodHistory>> getInRange(int goodId, DateTime start, DateTime end) async{
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

  Future<List<GoodHistory>> getData(List<Document> documents, int goodId) async{
    List<GoodHistory> results = [];
    for (Document document in documents){
      int documentId = document.id!;
      var transactions = await documentTransactionRepository.getTransactionsByDocumentIdAndGoodId(documentId, goodId);
      var quantity = 0.0;
      var amount = 0.0;
      for (DocumentTransaction transaction in transactions){
        quantity += transaction.quantity;
        if (transaction.price != null){
          amount += transaction.quantity*transaction.price!;
        }
      }
      //var quantity = await documentTransactionRepository.getSumQuantityByGoodIdAndByDocumentId(document.type, goodId, documentId);
      //if (quantity > 0){
      //  results.add(GoodHistory(document, quantity));
      //}
      if (transactions.isNotEmpty){
        results.add(GoodHistory(document, quantity, amount));
      }
    }
    return results;
  }
}