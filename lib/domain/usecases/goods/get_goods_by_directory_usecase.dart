import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';

class GetGoodsByDirectoryUseCase
    extends UseCase<List<Good>, GetGoodsByDirectoryUseCaseParams> {
  final GoodRepository _repository;

  GetGoodsByDirectoryUseCase(this._repository);

  @override
  Future<Stream<List<Good>>> buildUseCaseStream(
      GetGoodsByDirectoryUseCaseParams params) async {
    final StreamController<List<Good>> controller = StreamController();
    try {
      List<Good> items = await _repository.getGoodsByDirectory(params.directory);
      controller.add(items);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetGoodsByDirectoryUseCaseParams {
  final String directory;

  GetGoodsByDirectoryUseCaseParams(this.directory);
}