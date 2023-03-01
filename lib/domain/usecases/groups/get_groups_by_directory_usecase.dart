import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/repositories/group_repositories.dart';

class GetGroupsByDirectoryUseCase
    extends UseCase<List<Group>, GetGroupsByDirectoryUseCaseParams> {
  final GroupRepository _repository;

  GetGroupsByDirectoryUseCase(this._repository);

  @override
  Future<Stream<List<Group>>> buildUseCaseStream(
      GetGroupsByDirectoryUseCaseParams params) async {
    final StreamController<List<Group>> controller = StreamController();
    try {
      List<Group> items = await _repository.getGroupsByDirectory(params.directory);
      controller.add(items);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetGroupsByDirectoryUseCaseParams {
  final String directory;

  GetGroupsByDirectoryUseCaseParams(this.directory);
}