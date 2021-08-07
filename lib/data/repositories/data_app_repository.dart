import 'package:good_manager/data/utils/constants.dart';
import 'package:good_manager/domain/entities/barcode_scanner_settings.dart';
import 'package:good_manager/domain/entities/customers_settings.dart';
import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:good_manager/domain/repositories/app_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataAppRepository implements AppRepository {
  //Singleton object of 'DataStoreRepository'
  static DataAppRepository _instance = DataAppRepository._internal();

  //Constructor
  DataAppRepository._internal() {}

  factory DataAppRepository() => _instance;

  @override
  Future<CustomersSettings> getSettings() async {
    var settings = CustomersSettings();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    settings.sortByName = SortByTextHelper.get(
        preferences.getInt(Constants.sortByNameCustomerKey));
    return settings;
  }

  @override
  Future<bool> setSettings(CustomersSettings settings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(Constants.sortByNameCustomerKey,
        SortByTextHelper.getValue(settings.sortByName));
  }

  @override
  Future<BarcodeScannerSettings> getBarcodeScannerSettings() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var settings = BarcodeScannerSettings();
    settings.batchModeScan = BatchModeScanHelper.get(
        preferences.getInt(Constants.barcodeScannerBatchModeScanKey));
    settings.enableVibrate =
        preferences.getBool(Constants.barcodeScannerEnableVibrateKey);
    settings.enableBeep =
        preferences.getBool(Constants.barcodeScannerEnableBeepKey);
    return settings;
  }

  @override
  Future<void> setBarcodeScannerSettings(
      BarcodeScannerSettings settings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(Constants.barcodeScannerBatchModeScanKey,
        BatchModeScanHelper.getValue(settings.batchModeScan));
    preferences.setBool(
        Constants.barcodeScannerEnableBeepKey, settings.enableBeep);
    preferences.setBool(
        Constants.barcodeScannerEnableVibrateKey, settings.enableVibrate);
  }
}
