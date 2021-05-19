import 'package:good_manager/data/utils/constants.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/sort_by.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/supplier_settings.dart';
import 'package:good_manager/domain/repositories/supplier_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSupplierRepository implements SupplierRepository {
  //Singleton object of 'DataStoreRepository'
  static DataSupplierRepository _instance = DataSupplierRepository._internal();

  //Constructor
  DataSupplierRepository._internal() {}

  factory DataSupplierRepository() => _instance;

  var db = new DBHelper();

  @override
  Future<List<Supplier>> getAll() {
    return db.getSuppliers();
  }

  @override
  Future<bool> insert(Supplier supplier) {
    return db.insertSupplier(supplier);
  }

  @override
  Future<bool> update(Supplier supplier) {
    return db.updateSupplier(supplier);
  }

  @override
  Future<SupplierSettings> getSettings() async {
    var settings = SupplierSettings();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var value = preferences.getInt(Constants.sortByNameSupplierKey);
    if (value == null) {
      settings.sortByName = SortBy.no_sort;
    } else {
      settings.sortByName = SortByHelper.get(value);
    }
    return settings;
  }

  @override
  Future<bool> setSettings(SupplierSettings settings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(
        Constants.sortByNameSupplierKey, settings.sortByName.value);
  }

  @override
  Future<bool> delete(int id) {
    return db.deleteSupplier(id);
  }
}
