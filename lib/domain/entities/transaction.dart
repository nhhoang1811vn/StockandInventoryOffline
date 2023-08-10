import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/good.dart';

class DocumentTransaction{
  int id = -1;
  late int documentId;
  late int goodId;
  late int quantity;
  late DocumentType type;
  late int storeId;
  late Good good;
  late DateTime createdDate;
  late DateTime updatedDate;

  DocumentTransaction();

  DocumentTransaction.map(dynamic obj) {
    this.id = obj["id"];
    this.createdDate = DateTime.fromMillisecondsSinceEpoch(obj["createdDate"]);
    this.updatedDate = DateTime.fromMillisecondsSinceEpoch(obj["updatedDate"]);
    this.documentId = obj["documentId"];
    this.goodId = obj["goodId"];
    this.quantity = obj["quantity"];
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

    map["createdDate"] = createdDate.millisecondsSinceEpoch;
    map["updatedDate"] = updatedDate.millisecondsSinceEpoch;
    return map;
  }
}