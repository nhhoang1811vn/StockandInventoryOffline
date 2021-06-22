import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/repositories/group_repositories.dart';

class InsertGroupUseCase extends UseCase<int, InsertGroupUseCaseParams> {
  final GroupRepository _repository;

  InsertGroupUseCase(this._repository);

  @override
  Future<Stream<int>> buildUseCaseStream(
      InsertGroupUseCaseParams params) async {
    final StreamController<int> controller = StreamController();
    try {
      int groupId = await _repository.insert(params.item);
      controller.add(groupId);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class InsertGroupUseCaseParams {
  final Group item;

  InsertGroupUseCaseParams(this.item);
}
