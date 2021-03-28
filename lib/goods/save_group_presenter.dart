import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/model/Group.dart';
import 'package:good_manager/model/Store.dart';

abstract class SaveGroupContract{

}

class SaveGroupPresenter{
  SaveGroupContract _view;
  var db = new DBHelper();

  SaveGroupPresenter(this._view);

  insert(Group item){
    db.insertGroup(item);
  }
  update(Group item){
    db.updateGroup(item);
  }
}