import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/model/Store.dart';

abstract class SaveStoreContract{

}

class SaveStorePresenter{
  SaveStoreContract _view;
  var db = new DBHelper();

  SaveStorePresenter(this._view);

  insert(Store store){
    db.insertStore(store);
  }
  update(Store store){
    db.updateStore(store);
  }
}