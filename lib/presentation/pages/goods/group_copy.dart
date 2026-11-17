import '../../../domain/entity/entity.dart';
import 'good_copy.dart';

/// Builds an unsaved copy of [source] (the group only, not its goods or
/// sub-groups) for the Save Group screen.
Group buildCopyOfGroup(
  Group source, {
  required int storeId,
  int? groupId,
}) {
  return Group()
    ..name = '${source.name}$goodCopyNameSuffix'
    ..description = source.description
    ..barCode = source.barCode
    ..file = source.file
    ..files = List.of(source.files)
    ..storeId = storeId
    ..groupId = groupId;
}
