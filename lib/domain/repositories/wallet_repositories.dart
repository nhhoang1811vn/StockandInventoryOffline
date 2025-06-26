import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class WalletRepository
    extends BaseRepository<Wallet> {
  Future<List<Wallet>> getAllByStoreId(int storeId);
  Future<int> getCount(int storeId);
}
