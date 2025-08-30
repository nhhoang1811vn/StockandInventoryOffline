import 'package:injectable/injectable.dart';

import '../data/app_settings.dart';
import '../data/data.dart';
import '../domain/entity/entity.dart';

@LazySingleton()
class GroupsRepository {
  final DBHelper db;

  GroupsRepository({required this.db});

  Future<int> insert(Group item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertGroup(item);
  }

  Future<bool> update(Group item) {
    item.updatedDate = DateTime.now();
    return db.updateGroup(item);
  }

  Future<bool> delete(int id) {
    return db.deleteGroup(id);
  }

  Future<Group> get(int id) {
    return db.findGroup(id);
  }

  Future<List<Group>> getGroupsByGroupId(int? groupId) {
    int storeId = AppSettings.getSelectedStoreId();
    return db.getGroupsByGroupId(storeId, groupId);
  }

  Future<List<Group>> getAllByStoreId(int storeId) {
    return db.getGroups(storeId);
  }
}
