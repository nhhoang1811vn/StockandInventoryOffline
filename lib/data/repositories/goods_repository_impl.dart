import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/goods_repositories.dart';
import 'package:injectable/injectable.dart';

import '../../app/main.dart';

@Injectable(as: GoodsRepository)
class GoodsRepositoryImpl implements GoodsRepository {
  GoodsRepositoryImpl();

  var db = new DBHelper();

  @override
  Future<int> insert(Good item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertGood(item);
  }

  @override
  Future<bool> update(Good item) {
    item.updatedDate = DateTime.now();
    return db.updateGood(item);
  }

  Future<List<Good>> getGoodsByDirectory(String directory){
    int storeId = storage.getSelectedStoreId();
    return db.getGoodsByDirectory(storeId, directory);
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
