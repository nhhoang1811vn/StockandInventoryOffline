import 'package:injectable/injectable.dart';

import '../../../repo/repo.dart';
import '../../entity/entity.dart';
import '../base/items_usecases.dart';

@LazySingleton()
class WalletUseCases extends ItemsUseCase<Wallet> {
  final WalletRepository repository;

  WalletUseCases({required this.repository});

  Future<int> insert(Wallet item) {
    return repository.insert(item);
  }

  Future<bool> update(Wallet item) {
    return repository.update(item);
  }

  Future<bool> delete(int id) {
    return repository.delete(id);
  }

  Future<List<Wallet>> getAllByStoreId(int storeId) {
    return repository.getAllByStoreId(storeId);
  }

  Future<int> getCount(int storeId) {
    return repository.getCount(storeId);
  }
}
