import 'package:injectable/injectable.dart';

import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../base/items_usecases.dart';

@LazySingleton()
class SuppliersUseCase extends ItemsUseCase<Supplier> {
  final SuppliersRepository repository;

  SuppliersUseCase({required this.repository});

  Future<int> insert(Supplier item) {
    return repository.insert(item);
  }

  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  Future<bool> update(Supplier item) {
    return repository.update(item);
  }

  Future<List<Supplier>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

  Future<int> getCount(int storeId) {
    return repository.getCount(storeId);
  }

  Future<Supplier> get(int id) {
    return repository.get(id);
  }
}
