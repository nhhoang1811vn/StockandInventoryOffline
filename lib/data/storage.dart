import 'dart:convert';

import 'package:good_manager/domain/entities/documents_setting.dart';
import 'package:good_manager/domain/entities/expenses_setting.dart';
import 'package:good_manager/domain/entities/goods_setting.dart';
import 'package:good_manager/domain/entities/stores_setting.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/suppliers_setting.dart';

@singleton
class Storage{
  late SharedPreferences prefs;
  Future<void> init() async{
    prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(StorageKeys.SuppliersSetting)){
      setSuppliersSetting(SuppliersSetting.getDefault());
    }
    if (!prefs.containsKey(StorageKeys.GoodsSetting)){
      setGoodsSetting(GoodsSetting.getDefault());
    }
    if (!prefs.containsKey(StorageKeys.ExpensesSetting)){
      setExpensesSetting(ExpensesSetting.getDefault());
    }
    if (!prefs.containsKey(StorageKeys.DocumentsSetting)){
      setDocumentsSetting(DocumentsSetting.getDefault());
    }
    if (!prefs.containsKey(StorageKeys.StoresSetting)){
      setStoresSetting(StoresSetting.getDefault());
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
  void setSuppliersSetting(SuppliersSetting settings){
    prefs.setString(StorageKeys.SuppliersSetting, jsonEncode(settings.toJson()));
  }
  SuppliersSetting getSuppliersSetting() {
    Map<String, Object?> json = jsonDecode(prefs.getString(StorageKeys.SuppliersSetting)!);
    return SuppliersSetting.fromJson(json);
  }

  void setGoodsSetting(GoodsSetting settings){
    prefs.setString(StorageKeys.GoodsSetting, jsonEncode(settings.toJson()));
  }
  GoodsSetting getGoodsSetting(){
    Map<String, Object?> json = jsonDecode(prefs.getString(StorageKeys.GoodsSetting)!);
    return GoodsSetting.fromJson(json);
  }
  void setExpensesSetting(ExpensesSetting settings){
    prefs.setString(StorageKeys.ExpensesSetting, jsonEncode(settings.toJson()));
  }
  ExpensesSetting getExpensesSetting(){
    Map<String, Object?> json = jsonDecode(prefs.getString(StorageKeys.ExpensesSetting)!);
    return ExpensesSetting.fromJson(json);
  }
  void setStoresSetting(StoresSetting settings){
    prefs.setString(StorageKeys.StoresSetting, jsonEncode(settings.toJson()));
  }
  StoresSetting getStoresSetting(){
    Map<String, Object?> json = jsonDecode(prefs.getString(StorageKeys.StoresSetting)!);
    return StoresSetting.fromJson(json);
  }

  void setDocumentsSetting(DocumentsSetting settings){
    prefs.setString(StorageKeys.DocumentsSetting, jsonEncode(settings.toJson()));
  }
  DocumentsSetting getDocumentsSetting(){
    Map<String, Object?> json = jsonDecode(prefs.getString(StorageKeys.DocumentsSetting)!);
    return DocumentsSetting.fromJson(json);
  }

  int getAutoDocumentNo(int storeId){
    int? value = prefs.getInt(StorageKeys.AutoDocumentName + storeId.toString());
    if (value == null){
      return 1;
    }else{
      return value + 1;
    }
  }
}
class StorageKeys{
  static const String SelectedStoreId = "SelectedStoreId";
  static const String SelectedStoreName = "SelectedStoreName";
  static const String FirstTime = "FirstTime";
  static const String LanguageCode = "LanguageCode";

  static const String StoresSetting = "StoresSetting";
  static const String SuppliersSetting = "SuppliersSetting";
  static const String GoodsSetting = "GoodsSetting";
  static const String ExpensesSetting = "ExpensesSetting";
  static const String DocumentsSetting = "DocumentsSetting";

  static const String AutoDocumentName = "AutoDocumentName";
}