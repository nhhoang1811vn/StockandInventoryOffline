import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

class BaseUpdateItemUseCase<M extends BaseModel>
    extends CompletableUseCase<BaseUpdateItemUseCaseParam> {
  final BaseRepository repository;

  BaseUpdateItemUseCase(this.repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      BaseUpdateItemUseCaseParam params) async {
    final StreamController<void> controller = StreamController();
    try {
      await repository.update(params.item);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class BaseUpdateItemUseCaseParam<M extends BaseModel> {
  final M item;

  BaseUpdateItemUseCaseParam(this.item);
}
