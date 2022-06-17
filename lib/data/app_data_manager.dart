
import 'package:good_manager/data/shared_prefs_helper.dart';

AppDataManager appDataManager = new AppDataManager();
class AppDataManager{
  static final AppDataManager _appDataManager = new AppDataManager.internal();
  SharedPrefsHelper sharedPrefsHelper = new SharedPrefsHelper();

  factory AppDataManager(){
    return _appDataManager;
  }
  AppDataManager.internal();
}