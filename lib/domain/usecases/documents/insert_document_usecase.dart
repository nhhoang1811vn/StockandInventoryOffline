import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';

class InsertDocumentUseCase extends UseCase<int, InsertDocumentUseCaseParams> {
  final DocumentRepository _documentRepository;

  InsertDocumentUseCase(this._documentRepository);

  @override
  Future<Stream<int>> buildUseCaseStream(
      InsertDocumentUseCaseParams params) async {
    final StreamController<int> controller = StreamController();
    try {
      int documentId = await _documentRepository.insertDocument(params.document, params.transactions);
      controller.add(documentId);
      controller.close();
    } catch (e) {
      controller.addError(e.message);
    }
    return controller.stream;
  }
}

class InsertDocumentUseCaseParams {
  final Document document;
  final List<DocumentTransaction> transactions;

  InsertDocumentUseCaseParams(this.document, this.transactions);
}
