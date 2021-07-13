import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/repositories/group_repositories.dart';

class GetGroupsByGroupIdUseCase
    extends UseCase<List<Group>, GetGroupsByGroupIdUseCaseParams> {
  final GroupRepository _repository;

  GetGroupsByGroupIdUseCase(this._repository);

  @override
  Future<Stream<List<Group>>> buildUseCaseStream(
      GetGroupsByGroupIdUseCaseParams params) async {
    final StreamController<List<Group>> controller = StreamController();
    try {
      List<Group> items = await _repository.getGroupsByGroupId(params.groupId);
      controller.add(items);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetGroupsByGroupIdUseCaseParams {
  final int groupId;

  GetGroupsByGroupIdUseCaseParams(this.groupId);
}