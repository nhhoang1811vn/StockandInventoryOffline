import 'package:good_manager/domain/entities/group.dart';

import 'base_repository.dart';

abstract class GroupsRepository extends BaseRepository<Group> {
  Future<List<Group>> getGroupsByGroupId(int? groupId);
  Future<List<Group>> getAllByStoreId(int storeId);

}
