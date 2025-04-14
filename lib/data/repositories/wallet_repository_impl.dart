import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/wallet_repositories.dart';

@Injectable(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl();

  var db = new DBHelper();
  @override
  Future<int> insert(Wallet item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertWallet(item);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteWallet(id);
  }

  @override
  Future<Wallet> get(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Wallet>> getAll() {
    throw UnimplementedError();
  }
  @override
  Future<List<Wallet>> getAllByStoreId(int storeId) {
    return db.getWalletByStoreId(storeId);
  }

  @override
  Future<bool> update(Wallet item) {
    item.updatedDate = DateTime.now();
    return db.updateWallet(item);
  }
}
