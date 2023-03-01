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
  Future<int> insert(Group item) {
    return db.insertGroup(item);
  }

  @override
  Future<bool> update(Group item) {
    return db.updateGroup(item);
  }

  @override
  Future<List<Group>> getGroupsByDirectory(String directory) {
    return db.getGroupsByDirectory(directory);
  }

  @override
  Future<bool> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Group>> getAll() {
    return db.getGroups();
  }

  @override
  Future<int> getCount() {
    // TODO: implement getCount
    throw UnimplementedError();
  }

  @override
  Future<Group> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }
}
