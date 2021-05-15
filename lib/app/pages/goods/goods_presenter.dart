import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GoodsPresenter extends Presenter {
  GoodsPresenter();

  @override
  void dispose() {
    // TODO: implement dispose
  }

/*Future<List<GoodItem>> getItems(int groupId){
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
  }*/
}