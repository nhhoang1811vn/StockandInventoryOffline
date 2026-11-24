import 'package:injectable/injectable.dart';

import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../base/barcode_uniqueness.dart';
import '../base/items_usecases.dart';

@LazySingleton()
class GoodsUseCases extends ItemsUseCase<Good> {
  final GoodsRepository repository;
  final DocumentTransactionRepository documentTransactionRepository;
  final GroupsRepository groupsRepository;

  GoodsUseCases({
    required this.repository,
    required this.documentTransactionRepository,
    required this.groupsRepository,
  });

  Future<int> insert(Good item) async {
    await _ensureBarcodeAllowed(item);
    return repository.insert(item);
  }

  Future<bool> update(Good item) async {
    await _ensureBarcodeAllowed(item);
    return repository.update(item);
  }

  /// "Unique barcode" rule: no other Good or Group of the Good's Store may use
  /// its barcode. See [ensureBarcodeUnique].
  Future<void> _ensureBarcodeAllowed(Good item) {
    return ensureBarcodeUnique(
      storeId: item.storeId,
      barcode: item.barCode,
      selfId: item.id,
      selfIsGood: true,
      storedBarcode: () async => (await repository.get(item.id!)).barCode,
      goods: repository,
      groups: groupsRepository,
    );
  }

  Future<bool> delete(int id) async {
    return repository.delete(id);
  }

  Future<Good> getGoodsByBarCode(String barCode) {
    return repository.getGoodByBarcode(barCode);
  }

  Future<List<Good>> getGoodsByGroupId(int? groupId) {
    return repository.getGoodsByGroupId(groupId);
  }

  Future<List<Good>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

  Future<int> getCount(int storeId) {
    return repository.getCount(storeId);
  }

  Future<Good> get(int id) {
    return repository.get(id);
  }
}
