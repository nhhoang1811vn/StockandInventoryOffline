import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';
import 'package:good_manager/domain/repositories/transaction_repositories.dart';

class UpdateDocumentUseCase
    extends CompletableUseCase<UpdateDocumentUseCaseParams> {
  final DocumentRepository _documentRepository;
  final DocumentTransactionRepository _documentTransactionRepository;

  UpdateDocumentUseCase(
      this._documentRepository, this._documentTransactionRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      UpdateDocumentUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      bool successful = await _documentRepository.update(params.document);
      deleteTransaction(params.document.id);
      params.transactions.forEach((transaction) async {
        DocumentTransaction model = DocumentTransaction();
        model.documentId = params.document.id;
        model.goodId = transaction.goodId;
        model.quantity = transaction.quantity;
        model.type = params.document.type;
        await _documentTransactionRepository.insert(transaction);
      });
      if (successful) {
        controller.close();
      } else {
        throw Exception("insert failed");
      }
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }

  void deleteTransaction(int documentId) async {
    await _documentTransactionRepository.deleteByDocumentId(documentId);
  }
}

class UpdateDocumentUseCaseParams {
  final Document document;
  final List<DocumentTransaction> transactions;

  UpdateDocumentUseCaseParams(this.document, this.transactions);
}
