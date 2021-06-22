import 'package:good_manager/domain/entities/transaction.dart';

import 'base_repository.dart';

abstract class DocumentTransactionRepository
    extends BaseRepository<DocumentTransaction> {
  Future<bool> deleteByDocumentId(int documentId);

  Future<List<DocumentTransaction>> getTransactions(int documentId);
}
