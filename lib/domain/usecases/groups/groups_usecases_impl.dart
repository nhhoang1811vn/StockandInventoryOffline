import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/usecases/groups/groups_usecases.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/groups_repositories.dart';

@Injectable(as: GroupsUseCases)
class GroupsUseCaseImpl implements GroupsUseCases{
  final GroupsRepository repository;
  GroupsUseCaseImpl({required this.repository});
  @override
  Future<int> insert(Group item) {
    return repository.insert(item);
  }
  @override
  Future<bool> update(Group item) {
    return repository.update(item);
  }
  @override
  Future<List<Group>> getGroupsByGroupId(int? groupId) {
    return repository.getGroupsByGroupId(groupId);
  }
  @override
  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  @override
  Future<List<Group>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
  @override
  Future<List<Group>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

  @override
  Future<Group> getById(int id) {
    return repository.get(id);
  }

}