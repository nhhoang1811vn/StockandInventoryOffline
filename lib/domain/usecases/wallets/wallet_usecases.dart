import 'package:good_manager/domain/usecases/base/items_usecases.dart';

import '../../entities/wallet.dart';

abstract class WalletUseCases extends ItemsUseCase<Wallet>{
  Future<List<Wallet>> getAllByStoreId(int storeId);
  //Future<double> getSum(int storeId);
  //Future<List<Expense>> getExpensesInRange(DateTime start, DateTime end);
}