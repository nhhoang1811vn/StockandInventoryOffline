import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

class BaseGetItemsUseCase<M extends BaseModel> extends UseCase<List<M>, void> {
  final BaseRepository repository;

  BaseGetItemsUseCase(this.repository);

  @override
  Future<Stream<List<M>>> buildUseCaseStream(void params) async {
    final StreamController<List<M>> controller = StreamController();
    try {
      List<M> items = await repository.getAll();
      controller.add(items);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}
