import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/model/GoodItem.dart';
import 'package:good_manager/model/Group.dart';
import 'package:good_manager/model/Store.dart';

import 'dart:async';
abstract class GoodsContract{
  void screenUpdated();
}
class GoodsPresenter{
  GoodsContract _view;
  var db = DBHelper();

  GoodsPresenter(this._view);

  Future<List<GoodItem>> getItems(int groupId){
    var completer = new Completer<List<GoodItem>>();
    db.getGroups(groupId).then((value) {
      List<GoodItem> data = [];
      value.forEach((element) {
        GoodItem item = new GoodItem();
        item.id = element.id;
        item.quality = 10;
        item.group = element;
        data.add(item);
      });
      db.getGoods(groupId).then((value){
        value.forEach((element) {
          GoodItem item = new GoodItem();
          item.id = element.id;
          item.quality = 5;
          item.good = element;
          data.add(item);
        });
        completer.complete(data);
      });
    });
    return completer.future;
  }
  void refresh(){
    _view.screenUpdated();
  }
}