import 'package:injectable/injectable.dart';

import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../base/items_usecases.dart';

@LazySingleton()
class GroupsUseCases extends ItemsUseCase<Group> {
  final GroupsRepository repository;

  GroupsUseCases({required this.repository});

  Future<int> insert(Group item) {
    return repository.insert(item);
  }

  Future<bool> update(Group item) {
    return repository.update(item);
  }

  Future<List<Group>> getGroupsByGroupId(int? groupId) {
    return repository.getGroupsByGroupId(groupId);
  }

  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  Future<List<Group>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

  Future<Group> getById(int id) {
    return repository.get(id);
  }
}
