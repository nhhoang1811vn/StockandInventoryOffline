import 'package:injectable/injectable.dart';

import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../base/items_usecases.dart';

@LazySingleton()
class GoodsUseCases extends ItemsUseCase<Good> {
  final GoodsRepository repository;
  final DocumentTransactionRepository documentTransactionRepository;

  GoodsUseCases({
    required this.repository,
    required this.documentTransactionRepository,
  });

  Future<int> insert(Good item) {
    return repository.insert(item);
  }

  Future<bool> update(Good item) {
    return repository.update(item);
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
