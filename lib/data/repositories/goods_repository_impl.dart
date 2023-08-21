import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/goods_repositories.dart';
import 'package:injectable/injectable.dart';

import '../../presentation/main.dart';

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
  @override
  Future<List<Good>> getGoodsByGroupId(int? groupId) {
    int storeId = storage.getSelectedStoreId();
    return db.getGoodsByGroupId(storeId,groupId);
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
  Future<List<Good>> getAllByStoreId(int storeId) {
    return db.getGoods(storeId);
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
