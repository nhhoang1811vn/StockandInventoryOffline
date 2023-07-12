import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/goods_repositories.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GoodsRepository)
class GoodsRepositoryImpl implements GoodsRepository {
  GoodsRepositoryImpl();

  var db = new DBHelper();

  @override
  Future<int> insert(Good item) {
    return db.insertGood(item);
  }

  @override
  Future<bool> update(Good item) {
    return db.updateGood(item);
  }

  Future<List<Good>> getGoodsByDirectory(String directory){
    // TODO: implement get
    throw UnimplementedError();
    //return db.getGoodsByDirectory(directory);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteGood(id);
  }

  @override
  Future<List<Good>> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<int> getCount(int storeId) {
    return db.getCountGood(storeId);
  }

  @override
  Future<Good> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Good> getGoodByBarcode(String barcode) {
    return db.getGoodByBarcode(barcode);
  }
}
