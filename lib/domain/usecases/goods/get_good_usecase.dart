import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';

class GetGoodsByGroupIdUseCase
    extends UseCase<List<Good>, GetGoodsByGroupIdUseCaseParams> {
  final GoodRepository _repository;

  GetGoodsByGroupIdUseCase(this._repository);

  @override
  Future<Stream<List<Good>>> buildUseCaseStream(
      GetGoodsByGroupIdUseCaseParams params) async {
    final StreamController<List<Good>> controller = StreamController();
    try {
      List<Good> items = await _repository.getGoodsByGroupId(params.groupId);
      controller.add(items);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetGoodsByGroupIdUseCaseParams {
  final int groupId;

  GetGoodsByGroupIdUseCaseParams(this.groupId);
}