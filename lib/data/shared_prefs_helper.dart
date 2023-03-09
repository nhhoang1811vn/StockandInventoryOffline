import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

const String keySortByStore = "sort_by_store";
const String keySelectedStoreId = "key_selected_store_id";
const String keySelectedStoreName = "keySelectedStoreName";
const String keyFirstTime = "key_first_time";
const String keyAutoDocumentName = "key_auto_document_name";
const String keyLanguageCode = "keyLanguageCode";

const String ENGLISH = "en";
const String VIETNAMESE = "vi";
class SharedPrefsHelper{
  SharedPreferences prefs;
  Future<String> getAutoDocumentName() async{
    prefs = await SharedPreferences.getInstance();
    int index;
    if (prefs.containsKey(keyAutoDocumentName)){
      index = prefs.getInt(keyAutoDocumentName);
    }else{
      index = 1;
    }
    prefs.setInt(keyAutoDocumentName, index+ 1);
    return "Giao dich $index";
  }

  void increaseAutoDocumentName() async {
    prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(keyAutoDocumentName);
    prefs.setInt(keyAutoDocumentName, value + 1);
  }

  void setFirstTime(bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(keyFirstTime, value);
  }

  Future<bool> getFirstTime() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyFirstTime) ?? true;
  }

  void setSelectedStoreId(int storeId) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt(keySelectedStoreId, storeId);
  }

  Future<int> getSelectedStoreId() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keySelectedStoreId);
  }

  void setSelectedStoreName(String storeName) async{
    prefs = await SharedPreferences.getInstance();
    prefs.setString(keySelectedStoreName, storeName);
  }
  Future<String> getSelectedStoreName() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(keySelectedStoreName);
  }


  Future<String> getLanguageCode() async {
    String deviceLanguageCode = Platform.localeName;
    String defaultLanguageCode = ENGLISH;
    if (deviceLanguageCode == "vi_VN") {
      defaultLanguageCode = VIETNAMESE;
    } else {
      defaultLanguageCode = ENGLISH;
    }
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(keyLanguageCode) ?? defaultLanguageCode;
    return languageCode;
  }

  Future<void> setLanguageCode(String code) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(keyLanguageCode, code);
  }

}