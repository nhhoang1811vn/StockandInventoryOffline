import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';
import 'package:good_manager/domain/repositories/transaction_repositories.dart';

class DeleteDocumentUseCase
    extends CompletableUseCase<DeleteDocumentUseCaseParams> {
  final DocumentRepository _documentRepository;

  DeleteDocumentUseCase(this._documentRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      DeleteDocumentUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      await _documentRepository.deleteDocument(params.id);
      controller.close();
    } catch (e) {
      controller.addError(e.message);
    }
    return controller.stream;
  }
}

class DeleteDocumentUseCaseParams {
  final int id;

  DeleteDocumentUseCaseParams(this.id);
}
