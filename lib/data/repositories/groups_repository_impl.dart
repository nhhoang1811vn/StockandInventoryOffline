import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/repositories/groups_repositories.dart';
import 'package:injectable/injectable.dart';

import '../../main.dart';

@Injectable(as: GroupsRepository)
class GroupsRepositoryImpl implements GroupsRepository {
  GroupsRepositoryImpl();

  var db = new DBHelper();

  @override
  Future<int> insert(Group item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertGroup(item);
  }

  @override
  Future<bool> update(Group item) {
    item.updatedDate = DateTime.now();
    return db.updateGroup(item);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteGroup(id);
  }

  @override
  Future<Group> get(int id) {
    return db.findGroup(id);
  }

  @override
  Future<List<Group>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<int> getCount() {
    // TODO: implement getCount
    throw UnimplementedError();
  }
  @override
  Future<List<Group>> getGroupsByGroupId(int? groupId) {
    int storeId = storage.getSelectedStoreId();
    return db.getGroupsByGroupId(storeId, groupId);
  }
  @override
  Future<List<Group>> getAllByStoreId(int storeId) {
    return db.getGroups(storeId);
  }
}
