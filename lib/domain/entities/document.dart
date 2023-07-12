import 'package:good_manager/domain/entities/base_model.dart';

enum DocumentType {
  incoming,
  outgoing,
}

class Document extends BaseModel {
  DateTime date = DateTime.now();
  late DocumentType type;
  int? supplierId;
  String? supplierName;
  String? customerName;
  int? customerId;
  int? storeId;
  int quantity = 0;

  Document();

  Document clone() {
    Document newDocument = Document();
    newDocument.name = this.name;
    newDocument.description = this.description;
    newDocument.supplierId = this.supplierId;
    newDocument.customerId = this.customerId;
    newDocument.date = this.date;
    newDocument.type = this.type;
    return newDocument;
  }

  Document.map(dynamic obj) {
    super.map(obj);
    this.date = DateTime.fromMillisecondsSinceEpoch(obj["date"]);
    DocumentType.values.forEach((element) {
      if (obj["type"] == element.index) {
        this.type = element;
        return;
      }
    });
    this.supplierId = obj["supplierId"];
    this.customerId = obj["customerId"];
    this.storeId = obj["storeId"];
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["date"] = date.millisecondsSinceEpoch;
    map["type"] = type.index;
    map["supplierId"] = supplierId;
    map["customerId"] = customerId;
    map["storeId"] = storeId;
    return map;
  }
}