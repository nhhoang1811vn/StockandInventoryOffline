import 'package:good_manager/domain/entities/group.dart';

import 'base_repository.dart';

abstract class GroupRepository extends BaseRepository<Group> {
  Future<List<Group>> getGroups(int groupId);
}
