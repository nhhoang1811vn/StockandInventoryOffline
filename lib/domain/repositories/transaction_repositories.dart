import 'package:good_manager/domain/entities/transaction.dart';

import 'base_repository.dart';

abstract class DocumentTransactionRepository
    extends BaseRepository<DocumentTransaction> {
  Future<void> deleteByDocumentId(int documentId);

  Future<void> deleteByGoodId(int goodId);

  Future<List<DocumentTransaction>> getTransactions(int documentId);

  Future<int> getSumQuantity();
}
