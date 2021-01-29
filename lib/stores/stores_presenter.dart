import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/model/Store.dart';

import 'dart:async';
abstract class StoresContract{
  void screenUpdated();
}
class StoresPresenter{
  StoresContract _view;
  var db = DBHelper();

  StoresPresenter(this._view);

  Future<List<Store>> getStores(){
    return db.getStore();
  }
  void refresh(){
    _view.screenUpdated();
  }
}