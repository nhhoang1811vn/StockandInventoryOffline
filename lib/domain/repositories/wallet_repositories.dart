import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class WalletRepository
    extends BaseRepository<Wallet> {
  Future<List<Wallet>> getAllByStoreId(int storeId);
  //Future<double> getSum(int storeId);
  //Future<List<Expense>> getInRange(DateTime start, DateTime end);
}
