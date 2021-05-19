import 'package:good_manager/domain/entities/good.dart';

import 'base_repository.dart';

abstract class GoodRepository extends BaseRepository<Good> {
  Future<List<Good>> getGoods(int storeId, int groupId);
}
