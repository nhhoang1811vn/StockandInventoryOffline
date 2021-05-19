import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';

class InsertGoodUseCase extends CompletableUseCase<InsertGoodUseCaseParams> {
  final GoodRepository _repository;

  InsertGoodUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      InsertGoodUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      bool successful = await _repository.insert(params.item);
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

class InsertGoodUseCaseParams {
  final Good item;

  InsertGoodUseCaseParams(this.item);
}
