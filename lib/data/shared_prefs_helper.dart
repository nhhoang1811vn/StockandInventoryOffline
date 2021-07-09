import 'package:good_manager/assets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void setSelectedStoreName(String name) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(keySelectedStoreName, name);
  }

  Future<int> getSelectedStoreId() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keySelectedStoreId);
  }

  Future<String> getSelectedStoreName() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(keySelectedStoreName);
  }
}