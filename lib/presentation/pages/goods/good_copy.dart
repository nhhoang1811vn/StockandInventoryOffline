import '../../../domain/entity/entity.dart';

const String goodCopyNameSuffix = ' (copy)';

/// Builds an unsaved copy of [source] for the Save Good screen.
/// Stock quantity is derived (never copied) and the copy has no id.
Good buildCopyOfGood(
  Good source, {
  required int storeId,
  int? groupId,
}) {
  return Good()
    ..name = '${source.name}$goodCopyNameSuffix'
    ..description = source.description
    ..barCode = source.barCode
    ..purchasePrice = source.purchasePrice
    ..salePrice = source.salePrice
    ..minQuantity = source.minQuantity
    ..files = List.of(source.files)
    ..storeId = storeId
    ..groupId = groupId;
}
