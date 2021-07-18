import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';

class UpdateDocumentUseCase
    extends CompletableUseCase<UpdateDocumentUseCaseParams> {
  final DocumentRepository _documentRepository;

  UpdateDocumentUseCase(this._documentRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      UpdateDocumentUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      bool successful = await _documentRepository.updateDocument(params.document, params.transactions);
      if (successful) {
        controller.close();
      } else {
        throw Exception("update failed");
      }
    } catch (e) {
      controller.addError(e.message);
    }
    return controller.stream;
  }
}

class UpdateDocumentUseCaseParams {
  final Document document;
  final List<DocumentTransaction> transactions;

  UpdateDocumentUseCaseParams(this.document, this.transactions);
}
