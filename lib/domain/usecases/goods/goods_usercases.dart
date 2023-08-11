import 'package:good_manager/domain/usecases/base/items_usecases.dart';

import '../../entities/good.dart';

abstract class GoodsUseCases extends ItemsUseCase<Good>{
  Future<Good> getGoodsByBarCode(String barCode);
  Future<List<Good>> getGoodsByGroupId(int? groupId);
  Future<int> getCount(int storeId);
}