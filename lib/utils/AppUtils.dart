import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_manager/assets/constants.dart' as Constants;
class AppUtils{
  static Future<int> getSelectedStoreId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(Constants.KEY_SELECTED_STORE_ID);
  }
}