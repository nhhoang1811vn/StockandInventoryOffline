import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/repositories/document_repositories.dart';
import 'package:good_manager/domain/repositories/transaction_repositories.dart';

class InsertDocumentUseCase
    extends CompletableUseCase<InsertDocumentUseCaseParams> {
  final DocumentRepository _documentRepository;
  final DocumentTransactionRepository _documentTransactionRepository;

  InsertDocumentUseCase(
      this._documentRepository, this._documentTransactionRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      InsertDocumentUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      bool successful = await _documentRepository.insert(params.item);
      //TODO
      //_transactionRepository.in
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
}

class InsertDocumentUseCaseParams {
  final Document item;

  InsertDocumentUseCaseParams(this.item);
}
