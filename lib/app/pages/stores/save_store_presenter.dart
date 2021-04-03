import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/Store.dart';

abstract class SaveStoreContract{

}

class SaveStorePresenter{
  SaveStoreContract _view;
  var db = new DBHelper();

  SaveStorePresenter(this._view);

  Future<int> insert(Store store){
    return db.insertStore(store);
  }
  update(Store store){
    db.updateStore(store);
  }
}