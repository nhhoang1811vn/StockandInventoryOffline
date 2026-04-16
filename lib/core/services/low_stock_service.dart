import 'package:injectable/injectable.dart';

import '../../data/app_settings.dart';
import '../../repo/repo.dart';

@lazySingleton
class LowStockService {
  final GoodsRepository _repository;

  LowStockService(this._repository);

  // Future<List<Good>> getLowStockItems() async {
  //   final goods = await _repository.getAllGoods();
  //   return goods.where((g) => g.quantity < g.minQuantity).toList();
  // }

  Future<bool> hasLowStock() async {
    final storeId = AppSettings.getSelectedStoreId();
    final goods = await _repository.getAllByStoreId(storeId);
    return goods
        .any((g) => (g.minQuantity != null && g.quantity < g.minQuantity!));
  }
}
