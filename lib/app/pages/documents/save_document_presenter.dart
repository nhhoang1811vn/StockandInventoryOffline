import 'dart:async';

import 'package:good_manager/db/db_helper.dart';
import 'package:good_manager/domain/entities/Document.dart';
import 'package:good_manager/domain/entities/DocumentTransaction.dart';
import 'package:good_manager/domain/entities/Good.dart';
import 'package:good_manager/domain/entities/Supplier.dart';

abstract class DocumentsContract {
  void screenUpdated();
}

class SaveDocumentsPresenter {
  var db = DBHelper();

  SaveDocumentsPresenter();

  Future<int> insertDocument(Document item) {
    return db.insertDocument(item);
  }

  Future<bool> updateDocument(Document item) {
    return db.updateDocument(item);
  }

  Future<int> insertDocumentTransaction(DocumentTransaction item) {
    return db.insertDocumentTransaction(item);
  }

  Future<int> deleteDocumentTransaction(int documentId) {
    return db.deleteDocumentTransaction(documentId);
  }

  Future<List<Good>> getGoodByDocumentId(int documentId) {
    return db.getGoodByDocumentId(documentId);
  }

  Future<Supplier> getSupplier(int supplierId) {
    return db.getSupplier(supplierId);
  }
}
