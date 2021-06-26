import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/goods_settings.dart';

import 'base_repository.dart';

abstract class GoodRepository extends BaseRepository<Good> {
  Future<List<Good>> getGoods(int storeId, int groupId);

  Future<GoodsSettings> getSettings();

  Future<void> setSettings(GoodsSettings settings);
}
