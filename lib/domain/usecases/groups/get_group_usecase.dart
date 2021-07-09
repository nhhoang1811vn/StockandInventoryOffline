import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/repositories/group_repositories.dart';

class GetGroupUseCase extends UseCase<List<Group>,GetGroupUseCaseParams>{
  final GroupRepository _repository;

  GetGroupUseCase(this._repository);

  @override
  Future<Stream<List<Group>>> buildUseCaseStream(GetGroupUseCaseParams params) async{
    final StreamController<List<Group>> controller = StreamController();
    try{
      List<Group> items = await _repository.getGroups(params.groupId);
      controller.add(items);
      controller.close();
    }catch(e){
      controller.addError(e);
    }
    return controller.stream;
  }
}
class GetGroupUseCaseParams {
  final int groupId;

  GetGroupUseCaseParams(this.groupId);
}