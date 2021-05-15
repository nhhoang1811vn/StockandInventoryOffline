import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Group.dart';
import 'package:good_manager/domain/repositories/group_repositories.dart';

class UpdateGroupUseCase extends CompletableUseCase<UpdateGroupUseCaseParams> {
  GroupRepository _repository;

  UpdateGroupUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      UpdateGroupUseCaseParams params) async {
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

class UpdateGroupUseCaseParams {
  final Group item;

  UpdateGroupUseCaseParams(this.item);
}
