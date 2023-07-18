import 'package:good_manager/app/main.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/repositories/groups_repositories.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GroupsRepository)
class GroupsRepositoryImpl implements GroupsRepository {
  GroupsRepositoryImpl();

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
  Future<bool> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Group> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
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
  Future<List<Group>> getGroupsByDirectory(String directory) {
    int storeId = storage.getSelectedStoreId();
    return db.getGroupsByDirectory(storeId, directory);
  }
  @override
  Future<List<Group>> getAllByStoreId(int storeId) {
    return db.getGroups(storeId);
  }
}
