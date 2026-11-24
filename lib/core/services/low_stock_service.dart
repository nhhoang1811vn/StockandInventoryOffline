import 'package:injectable/injectable.dart';

import '../../data/app_settings.dart';
import '../../domain/entity/entity.dart';
import '../../repo/repo.dart';

@lazySingleton
class LowStockService {
  final GoodsRepository _repository;

  LowStockService(this._repository);

  // Future<List<Good>> getLowStockItems() async {
  //   final goods = await _repository.getAllGoods();
  //   return goods.where((g) => g.quantity < g.minQuantity).toList();
  // }

  static bool anyLowStock(List<Good> goods, {required bool enabled}) =>
      enabled &&
      goods.any((g) => (g.minQuantity != null && g.quantity < g.minQuantity!));

  Future<bool> hasLowStock() async {
    if (!AppSettings.isMinQuantityEnabled()) return false;
    final storeId = AppSettings.getSelectedStoreId();
    final goods = await _repository.getAllByStoreId(storeId);
    return anyLowStock(goods, enabled: true);
  }
}
