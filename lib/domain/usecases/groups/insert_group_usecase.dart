import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/Group.dart';
import 'package:good_manager/domain/repositories/group_repositories.dart';

class InsertGroupUseCase extends CompletableUseCase<InsertGroupUseCaseParams> {
  final GroupRepository _repository;

  InsertGroupUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      InsertGroupUseCaseParams params) async {
    final StreamController<void> controller = StreamController();
    try {
      bool successful = await _repository.insert(params.item);
      if (successful) {
        controller.close();
      } else {
        throw Exception("insert failed");
      }
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
