import 'package:good_manager/data/utils/constants.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/good.dart';
import 'package:good_manager/domain/entities/goods_settings.dart';
import 'package:good_manager/domain/entities/search_goods_type.dart';
import 'package:good_manager/domain/entities/sort_by_number.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/domain/repositories/good_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataGoodRepository implements GoodRepository {
  //Singleton object of 'DataStoreRepository'
  static DataGoodRepository _instance = DataGoodRepository._internal();

  //Constructor
  DataGoodRepository._internal();

  factory DataGoodRepository() => _instance;

  var db = new DBHelper();

  @override
  Future<int> insert(Good item) {
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

  @override
  Future<GoodsSettings> getSettings() async {
    var settings = GoodsSettings();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    settings.sortByName =
        SortByTextHelper.get(preferences.getInt(Constants.sortByNameGoodsKey));
    settings.sortByBarcode = SortByNumberHelper.get(
        preferences.getInt(Constants.sortByBarCodeGoodsKey));
    settings.sortByQuantity = SortByNumberHelper.get(
        preferences.getInt(Constants.sortByQuantityGoodsKey));
    settings.searchGoodsType = SearchGoodsTypeHelper.get(
        preferences.getInt(Constants.searchGoodsTypeKey));
    return settings;
  }

  @override
  Future<void> setSettings(GoodsSettings settings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(Constants.sortByNameGoodsKey,
        SortByTextHelper.getValue(settings.sortByName));
    preferences.setInt(Constants.sortByBarCodeGoodsKey,
        SortByNumberHelper.getValue(settings.sortByBarcode));
    preferences.setInt(Constants.sortByQuantityGoodsKey,
        SortByNumberHelper.getValue(settings.sortByQuantity));
    preferences.setInt(Constants.searchGoodsTypeKey,
        SearchGoodsTypeHelper.getValue(settings.searchGoodsType));
  }
}
