import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/base_repository.dart';

abstract class GoodsRepository
    extends BaseRepository<Good> {
  Future<List<Good>> getGoodsByDirectory(String directory);
  Future<Good> getGoodByBarcode(String barcode);
  Future<int> getCount(int storeId);
}
