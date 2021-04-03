
import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/Store.dart';

class OnBoardingPresenter{
  var db = new DBHelper();
  Future<int> insertStore(Store store){
    return db.insertStore(store);
  }
  void setFirstTime(bool value){
    appDataManager.sharedPrefsHelper.setFirstTime(value);
  }
  void setSelectedStoreId(int storeId){
    appDataManager.sharedPrefsHelper.setSelectedStoreId(storeId);
  }
}