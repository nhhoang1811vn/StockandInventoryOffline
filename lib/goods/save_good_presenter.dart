import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/model/Document.dart';
import 'package:good_manager/model/DocumentTransaction.dart';
import 'package:good_manager/model/Good.dart';
import 'package:good_manager/model/Group.dart';
import 'package:good_manager/model/Store.dart';

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

  Future<int> insertDocument(Document item){
    return db.insertDocument(item);
  }
  Future<bool> updateDocument(Document item){
    return db.updateDocument(item);
  }
  Future<int> insertDocumentTransaction(DocumentTransaction item){
    return db.insertDocumentTransaction(item);
  }
}