import 'package:injectable/injectable.dart';

import '../../../data/app_settings.dart';
import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../../exception/duplicate_exceptions.dart';
import '../base/barcode_uniqueness.dart';
import '../base/items_usecases.dart';

@LazySingleton()
class GroupsUseCases extends ItemsUseCase<Group> {
  final GroupsRepository repository;
  final GoodsRepository goodsRepository;

  GroupsUseCases({required this.repository, required this.goodsRepository});

  Future<int> insert(Group item) async {
    await _ensureNameAllowed(item);
    await _ensureBarcodeAllowed(item);
    return repository.insert(item);
  }

  Future<bool> update(Group item) async {
    await _ensureNameAllowed(item);
    await _ensureBarcodeAllowed(item);
    return repository.update(item);
  }

  /// "Unique barcode" rule: no other Good or Group of the Group's Store may use
  /// its barcode. See [ensureBarcodeUnique].
  Future<void> _ensureBarcodeAllowed(Group item) {
    return ensureBarcodeUnique(
      storeId: item.storeId,
      barcode: item.barCode,
      selfId: item.id,
      selfIsGood: false,
      storedBarcode: () async => (await repository.get(item.id!)).barCode,
      goods: goodsRepository,
      groups: repository,
    );
  }

  static String _normalize(String name) => name.trim().toLowerCase();

  /// "Unique group" rule of the Group's own Store: no other Group of the whole
  /// Store (any folder level) may have the same name, compared trimmed and
  /// ignoring case. An unchanged name is always accepted, so a Group that was
  /// a duplicate before the rule was turned on can still be edited. Throws
  /// [DuplicateGroupNameException].
  Future<void> _ensureNameAllowed(Group item) async {
    if (!AppSettings.getGoodPropertiesSettings(storeId: item.storeId)
        .uniqueGroupName) {
      return;
    }
    final name = _normalize(item.name);
    if (name.isEmpty) return;
    if (item.id != null) {
      final stored = await repository.get(item.id!);
      if (_normalize(stored.name) == name) return;
    }
    final groups = await repository.getAllByStoreId(item.storeId);
    final taken =
        groups.any((g) => g.id != item.id && _normalize(g.name) == name);
    if (taken) throw DuplicateGroupNameException(item.name.trim());
  }

  Future<List<Group>> getGroupsByGroupId(int? groupId) {
    return repository.getGroupsByGroupId(groupId);
  }

  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  Future<List<Group>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

  Future<Group> getById(int id) {
    return repository.get(id);
  }
}
