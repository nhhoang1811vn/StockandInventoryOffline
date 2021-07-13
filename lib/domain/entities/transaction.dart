import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';

class DocumentTransaction extends BaseModel {
  int id;
  int documentId;
  int goodId;
  int quantity;
  DocumentType type;
  int storeId;

  int currentQuantity = 0;
  Good good;

  DocumentTransaction();

  DocumentTransaction.map(dynamic obj) {
    this.id = obj["id"];
    this.documentId = obj["documentId"];
    this.goodId = obj["goodId"];
    this.quantity = obj["quantity"];
    this.currentQuantity = obj["quantity"];
    DocumentType.values.forEach((element) {
      if (obj["documentType"] == element.index) {
        this.type = element;
        return;
      }
    });
    this.storeId = obj["storeId"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["documentId"] = documentId;
    map["goodId"] = goodId;
    map["quantity"] = quantity;
    map["documentType"] = type.index;
    map["storeId"] = storeId;
    return map;
  }
}