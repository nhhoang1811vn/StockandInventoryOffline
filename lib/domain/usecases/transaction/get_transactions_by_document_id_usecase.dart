import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/transaction.dart';
import 'package:good_manager/domain/repositories/transaction_repositories.dart';

class GetTransactionsByDocumentIdUseCase extends UseCase<
    List<DocumentTransaction>, GetTransactionsByDocumentIdUseCaseParams> {
  final DocumentTransactionRepository _repository;

  GetTransactionsByDocumentIdUseCase(this._repository);

  @override
  Future<Stream<List<DocumentTransaction>>> buildUseCaseStream(
      GetTransactionsByDocumentIdUseCaseParams params) async {
    final StreamController<List<DocumentTransaction>> controller =
        StreamController();
    try {
      List<DocumentTransaction> transactions =
          await _repository.getTransactions(params.documentId);
      controller.add(transactions);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetTransactionsByDocumentIdUseCaseParams {
  final int documentId;

  GetTransactionsByDocumentIdUseCaseParams(this.documentId);
}
