import 'package:injectable/injectable.dart';

import '../data/data.dart';
import '../domain/entity/entity.dart';

@LazySingleton()
class WalletRepository {
  final DBHelper db;

  WalletRepository({required this.db});

  Future<int> insert(Wallet item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertWallet(item);
  }

  Future<bool> delete(int id) {
    return db.deleteWallet(id);
  }

  Future<List<Wallet>> getAllByStoreId(int storeId) {
    return db.getWalletByStoreId(storeId);
  }

  Future<bool> update(Wallet item) {
    item.updatedDate = DateTime.now();
    return db.updateWallet(item);
  }

  Future<int> getCount(int storeId) {
    return db.getCountWallet(storeId);
  }
}
