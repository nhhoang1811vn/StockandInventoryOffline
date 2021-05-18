import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/repositories/group_repositories.dart';

class DataGroupRepository implements GroupRepository {
  //Singleton object of 'DataStoreRepository'
  static DataGroupRepository _instance = DataGroupRepository._internal();

  //Constructor
  DataGroupRepository._internal();

  factory DataGroupRepository() => _instance;

  var db = new DBHelper();

  @override
  Future<bool> insert(Group item) {
    return db.insertGroup(item);
  }

  @override
  Future<bool> update(Group item) {
    return db.updateGroup(item);
  }

  @override
  Future<List<Group>> getGroups(int storeId, int groupId) {
    return db.getGroups(storeId,groupId);
  }
}
