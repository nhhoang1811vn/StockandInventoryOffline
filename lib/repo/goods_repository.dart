import 'package:injectable/injectable.dart';

import '../data/app_settings.dart';
import '../data/data.dart';
import '../domain/entity/entity.dart';

@LazySingleton()
class GoodsRepository {
  final DBHelper db;

  GoodsRepository({required this.db});

  Future<int> insert(Good item) {
    item.createdDate = DateTime.now();
    item.updatedDate = DateTime.now();
    return db.insertGood(item);
  }

  Future<bool> update(Good item) {
    item.updatedDate = DateTime.now();
    return db.updateGood(item);
  }

  Future<List<Good>> getGoodsByGroupId(int? groupId) {
    int storeId = AppSettings.getSelectedStoreId();
    return db.getGoodsByGroupId(storeId, groupId);
  }

  Future<bool> delete(int id) {
    return db.deleteGood(id);
  }

  Future<List<Good>> getAll() {
    throw UnimplementedError();
  }

  Future<List<Good>> getAllByStoreId(int storeId) {
    return db.getGoods(storeId);
  }

  Future<int> getCount(int storeId) {
    return db.getCountGood(storeId);
  }

  Future<Good> get(int id) {
    return db.findGood(id);
  }

  Future<Good> getGoodByBarcode(String barcode) {
    return db.getGoodByBarcode(barcode);
  }
}
