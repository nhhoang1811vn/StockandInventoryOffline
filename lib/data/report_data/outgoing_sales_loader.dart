import 'package:good_manager/util/extension/date_time_ext.dart';

import '../../domain/entity/document.dart';
import '../../domain/entity/transaction.dart';
import '../../domain/usecase/documents/document_usecases.dart';

class OutgoingSales {
  final List<Document> documents;
  final Map<int, List<DocumentTransaction>> transactionsByDocumentId;

  const OutgoingSales({
    required this.documents,
    required this.transactionsByDocumentId,
  });
}

/// Documents in [start]..[end] (whole days) of the selected store, plus the
/// Transactions of every document of [type] (default outgoing).
Future<OutgoingSales> loadOutgoingSales({
  required DocumentUseCases documentUseCases,
  required DateTime start,
  required DateTime end,
  DocumentType type = DocumentType.outgoing,
}) async {
  final documents = await documentUseCases.getInRange(
    start.startOfDay(),
    end.endOfDay(),
  );
  final transactionsByDocumentId = <int, List<DocumentTransaction>>{};
  for (final document in documents) {
    if (document.type != type || document.id == null) {
      continue;
    }
    transactionsByDocumentId[document.id!] =
        await documentUseCases.getTransactionsByDocumentId(document.id!);
  }
  return OutgoingSales(
    documents: documents,
    transactionsByDocumentId: transactionsByDocumentId,
  );
}
