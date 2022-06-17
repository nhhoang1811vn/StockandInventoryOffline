import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';
import 'package:good_manager/domain/repositories/transaction_repositories.dart';

class DeleteGoodUseCase extends CompletableUseCase<DeleteGoodUseCaseParam> {
  final GoodRepository goodRepository;
  final DocumentTransactionRepository transactionRepository;

  DeleteGoodUseCase(this.goodRepository, this.transactionRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(DeleteGoodUseCaseParam params) async {
    final StreamController<void> controller = StreamController();
    try {
      await transactionRepository.deleteByGoodId(params.id);
      await goodRepository.delete(params.id);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class DeleteGoodUseCaseParam {
  final int id;

  DeleteGoodUseCaseParam(this.id);
}
