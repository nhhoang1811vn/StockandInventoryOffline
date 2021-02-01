import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/model/Store.dart';
import 'package:good_manager/model/Supplier.dart';

abstract class SaveSupplierContract{

}

class SaveSupplierPresenter{
  SaveSupplierContract _view;
  var db = new DBHelper();

  SaveSupplierPresenter(this._view);

  insert(Supplier item){
    db.insertSupplier(item);
  }
  update(Supplier item){
    db.updateSupplier(item);
  }
}