import 'package:good_manager/data/app_data_manager.dart';
import 'package:good_manager/db/db_helper.dart';
import 'dart:async';
import 'package:good_manager/domain/entities/Document.dart';
import 'package:good_manager/domain/entities/Good.dart';
abstract class DocumentsContract{
  void screenUpdated();
}
class DocumentsPresenter{
  DocumentsContract _view;
  var db = DBHelper();

  DocumentsPresenter();

  Future<List<Document>> getAllDocuments(){
    return db.getAllDocuments();
  }
  Future<List<Document>> getIncomingDocuments(){
    return db.getDocumentsByType(DocumentType.incoming);
  }
  Future<List<Document>> getOutgoingDocuments(){
    return db.getDocumentsByType(DocumentType.outgoing);
  }
  Future<List<Document>> getStockTakingDocuments(){
    return db.getDocumentsByType(DocumentType.stock_taking);
  }
  Future<int> insert(Document document){
    return db.insertDocument(document);
  }
  Future<bool> update(Document document){
    return db.updateDocument(document);
  }
  Future<List<Good>> getGoodByDocumentId(int documentId){
    return db.getGoodByDocumentId(documentId);
  }

  Future<String> getAutoDocumentName() async{
    return appDataManager.sharedPrefsHelper.getAutoDocumentName();
  }
}