import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';

class InsertGoodUseCase extends UseCase<int, InsertGoodUseCaseParams> {
  final GoodRepository _repository;

  InsertGoodUseCase(this._repository);

  @override
  Future<Stream<int>> buildUseCaseStream(InsertGoodUseCaseParams params) async {
    final StreamController<int> controller = StreamController();
    try {
      int goodId = await _repository.insert(params.item);
      controller.add(goodId);
      controller.close();
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
