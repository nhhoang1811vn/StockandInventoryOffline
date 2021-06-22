import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';

class UpdateGoodUseCase extends CompletableUseCase<UpdateGoodUseCaseParams> {
  GoodRepository _repository;

  UpdateGoodUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      UpdateGoodUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      bool successful = await _repository.update(params.item);
      if (successful) {
        controller.close();
      } else {
        throw Exception("update failed");
      }
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class UpdateGoodUseCaseParams {
  final Good item;

  UpdateGoodUseCaseParams(this.item);
}
