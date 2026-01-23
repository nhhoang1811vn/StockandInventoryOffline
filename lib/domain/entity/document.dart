import 'base_model.dart';

enum DocumentType {
  incoming,
  outgoing,
}

class Document extends BaseModel {
  DateTime date = DateTime.now();
  late DocumentType type;
  int? personId;
  int? storeId;

  String? personName;
  double quantity = 0.0;
  double amount = 0.0;
  double paid = 0.0;

  Document();

  Document clone() {
    Document newDocument = Document();
    newDocument.name = this.name;
    newDocument.description = this.description;
    newDocument.personId = this.personId;
    newDocument.date = this.date;
    newDocument.type = this.type;
    return newDocument;
  }

  Document.map(dynamic obj) {
    super.map(obj);
    this.date = DateTime.fromMillisecondsSinceEpoch(obj["date"]);
    this.type = DocumentType.values
        .firstWhere((element) => element.index == obj["type"]);
    if (type == DocumentType.incoming) {
      this.personId = obj["supplierId"];
      this.personName = obj["supplierName"];
    } else {
      this.personId = obj["customerId"];
      this.personName = obj["customerName"];
    }
    this.storeId = obj["storeId"];
    this.quantity = obj["quantity"] ?? 0.0;
    this.amount = obj["amount"] ?? 0.0;
    //this.paid = obj["paid"]??0.0;
  }

  @override
  Map<String, dynamic> toMap({bool includeId = false}) {
    var map = super.toMap();
    map["date"] = date.millisecondsSinceEpoch;
    map["type"] = type.index;
    if (type == DocumentType.incoming) {
      map["supplierId"] = personId;
    } else {
      map["customerId"] = personId;
    }
    map["storeId"] = storeId;
    return map;
  }
}
