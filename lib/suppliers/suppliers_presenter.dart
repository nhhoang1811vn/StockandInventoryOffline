import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/model/Supplier.dart';

import 'dart:async';
abstract class SuppliersContract{
  void screenUpdated();
}
class SuppliersPresenter{
  SuppliersContract _view;
  var db = DBHelper();

  SuppliersPresenter(this._view);

  Future<List<Supplier>> getSuppliers(){
    return db.getSuppliers();
  }
  void refresh(){
    _view.screenUpdated();
  }
}