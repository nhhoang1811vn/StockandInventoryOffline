import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

class BaseDeleteItemUseCase
    extends CompletableUseCase<BaseDeleteItemUseCaseParam> {
  final BaseRepository repository;

  BaseDeleteItemUseCase(this.repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      BaseDeleteItemUseCaseParam params) async {
    final StreamController<void> controller = StreamController();
    try {
      await repository.delete(params.id);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class BaseDeleteItemUseCaseParam {
  final int id;

  BaseDeleteItemUseCaseParam(this.id);
}
