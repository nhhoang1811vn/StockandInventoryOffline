import 'package:good_manager/data/utils/constants.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/domain/entities/store.dart';
import 'package:good_manager/domain/entities/stores_settings.dart';
import 'package:good_manager/domain/repositories/store_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataStoreRepository implements StoreRepository{
  //Singleton object of 'DataStoreRepository'
  static DataStoreRepository _instance = DataStoreRepository._internal();

  //Constructor
  DataStoreRepository._internal(){

  }

  factory DataStoreRepository() => _instance;

  var db = new DBHelper();


  @override
  Future<List<Store>> getAll() {
    return db.getStores();
  }

  @override
  Future<int> insert(Store store) {
    return db.insertStore(store);
  }

  @override
  Future<bool> update(Store store) {
    return db.updateStore(store);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteStore(id);
  }

  @override
  Future<StoresSettings> getSettings() async {
    var settings = StoresSettings();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    settings.sortByName =
        SortByTextHelper.get(preferences.getInt(Constants.sortByNameStoresKey));
    return settings;
  }

  @override
  Future<void> setSettings(StoresSettings settings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(Constants.sortByNameStoresKey,
        SortByTextHelper.getValue(settings.sortByName));
  }
}