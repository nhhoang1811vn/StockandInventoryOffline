import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';

class DataGoodRepository implements GoodRepository {
  //Singleton object of 'DataStoreRepository'
  static DataGoodRepository _instance = DataGoodRepository._internal();

  //Constructor
  DataGoodRepository._internal();

  factory DataGoodRepository() => _instance;

  var db = new DBHelper();

  @override
  Future<bool> insert(Good item) {
    return db.insertGood(item);
  }

  @override
  Future<bool> update(Good item) {
    return db.updateGood(item);
  }

  @override
  Future<List<Good>> getGoods(int storeId, int groupId) {
    return db.getGoods(storeId, groupId);
  }

  @override
  Future<bool> delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Good>> getAll() {
    throw UnimplementedError();
  }
}
