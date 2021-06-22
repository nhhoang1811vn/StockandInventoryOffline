import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';
import 'package:good_manager/domain/repositories/transaction_repositories.dart';

class InsertDocumentUseCase extends UseCase<int, InsertDocumentUseCaseParams> {
  final DocumentRepository _documentRepository;
  final DocumentTransactionRepository _documentTransactionRepository;

  InsertDocumentUseCase(
      this._documentRepository, this._documentTransactionRepository);

  @override
  Future<Stream<int>> buildUseCaseStream(
      InsertDocumentUseCaseParams params) async {
    final StreamController<int> controller = StreamController();
    try {
      int documentId = await _documentRepository.insert(params.document);
      params.transactions.forEach((transaction) async {
        DocumentTransaction item = DocumentTransaction();
        item.documentId = documentId;
        item.goodId = transaction.goodId;
        item.quantity = transaction.quantity;
        item.type = params.document.type;
        await _documentTransactionRepository.insert(item);
      });
      controller.add(documentId);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class InsertDocumentUseCaseParams {
  final Document document;
  final List<DocumentTransaction> transactions;

  InsertDocumentUseCaseParams(this.document, this.transactions);
}
