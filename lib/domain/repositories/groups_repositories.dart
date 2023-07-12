import 'package:good_manager/domain/entities/group.dart';

import 'base_repository.dart';

abstract class GroupsRepository extends BaseRepository<Group> {
  Future<List<Group>> getGroupsByDirectory(String directory);
}
