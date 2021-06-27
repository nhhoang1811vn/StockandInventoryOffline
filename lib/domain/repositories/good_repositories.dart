import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/goods_settings.dart';
import 'package:good_manager/domain/repositories/base_common_repository.dart';

abstract class GoodRepository
    extends BaseCommonRepository<Good, GoodsSettings> {
  Future<List<Good>> getGoods(int storeId, int groupId);
}
