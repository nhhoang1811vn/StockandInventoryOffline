import 'dart:convert';

import 'package:good_manager/domain/entities/sort_by_text.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/supplier_settings.dart';

@singleton
class Storage{
  late SharedPreferences prefs;
  Future<void> init() async{
    prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(StorageKeys.SupplierSettings)){
      setSupplierSettings(SupplierSettings.getDefault());
    }
  }
  int getSelectedStoreId() {
    return prefs.getInt(StorageKeys.SelectedStoreId)??-1;
  }

  void setSelectedStoreId(int storeId) {
    prefs.setInt(StorageKeys.SelectedStoreId, storeId);
  }
  String getSelectedStoreName(){
    return prefs.getString(StorageKeys.SelectedStoreName)??"";
  }
  void setSelectedStoreName(String value){
    prefs.setString(StorageKeys.SelectedStoreName, value);
  }
  bool getFirstTime() {
    return prefs.getBool(StorageKeys.FirstTime)??true;
  }
  void setFirstTime(bool value) {
    prefs.setBool(StorageKeys.FirstTime, value);
  }
  void setLanguageCode(String value) {
    prefs.setString(StorageKeys.LanguageCode, value);
  }
  String getLanguageCode() {
    return prefs.getString(StorageKeys.LanguageCode)??"vi";
  }
  void setSupplierSettings(SupplierSettings settings){
    prefs.setString(StorageKeys.SupplierSettings, jsonEncode(settings.toJson()));
  }
  SupplierSettings getSupplierSettings() {
    Map<String, Object?> json = jsonDecode(prefs.getString(StorageKeys.SupplierSettings)!);
    return SupplierSettings.fromJson(json);
  }
}
class StorageKeys{
  static const String SelectedStoreId = "SelectedStoreId";
  static const String SelectedStoreName = "SelectedStoreName";
  static const String FirstTime = "FirstTime";
  static const String LanguageCode = "LanguageCode";

  static const String SupplierSettings = "SupplierSettings";
}