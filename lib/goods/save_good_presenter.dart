import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/model/Good.dart';

abstract class SaveGoodContract{

}

class SaveGoodPresenter{
  SaveGoodContract _view;
  var db = new DBHelper();

  SaveGoodPresenter(this._view);

  Future<int> insertGood(Good item){
    return db.insertGood(item);
  }
  Future<bool> updateGood(Good item){
    return db.updateGood(item);
  }
}