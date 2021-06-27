import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

class BaseInsertItemUseCase<M extends BaseModel>
    extends UseCase<int, BaseInsertItemUseCaseParam> {
  final BaseRepository repository;

  BaseInsertItemUseCase(this.repository);

  @override
  Future<Stream<int>> buildUseCaseStream(
      BaseInsertItemUseCaseParam params) async {
    final StreamController<int> controller = StreamController();
    try {
      int id = await repository.insert(params.item);
      controller.add(id);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class BaseInsertItemUseCaseParam<M extends BaseModel> {
  final M item;

  BaseInsertItemUseCaseParam(this.item);
}
