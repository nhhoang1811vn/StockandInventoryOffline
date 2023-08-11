import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/usecases/base/items_usecases.dart';
abstract class GroupsUseCases extends ItemsUseCase<Group>{
  Future<List<Group>> getAllByStoreId(int storeId);
  Future<List<Group>> getGroupsByGroupId(int? groupId);
}