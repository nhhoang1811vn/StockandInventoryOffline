import 'package:good_manager/domain/app_settings.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/goods_repositories.dart';

@lazySingleton
class LowStockService {
  final GoodsRepository _repository;
  final AppSettings appSettings;
  LowStockService(this._repository, this.appSettings);

  // Future<List<Good>> getLowStockItems() async {
  //   final goods = await _repository.getAllGoods();
  //   return goods.where((g) => g.quantity < g.minQuantity).toList();
  // }

  Future<bool> hasLowStock() async {
    final storeId = appSettings.getSelectedStoreId();
    final goods = await _repository.getAllByStoreId(storeId);
    return goods.any((g) => (g.minQuantity != null && g.quantity < g.minQuantity!));
  }
}
