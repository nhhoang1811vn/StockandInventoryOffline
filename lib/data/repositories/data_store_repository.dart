import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/Store.dart';
import 'package:good_manager/domain/repositories/store_repositories.dart';

class DataStoreRepository implements StoreRepository{
  //Singleton object of 'DataStoreRepository'
  static DataStoreRepository _instance = DataStoreRepository._internal();
  //Constructor
  DataStoreRepository._internal(){

  }
  factory DataStoreRepository() => _instance;

  var db = new DBHelper();
  @override
  Future<int> insert(Store store) {
    return db.insertStore(store);
  }

  @override
  Future<List<Store>> getAll() {
    return db.getStores();
  }

}