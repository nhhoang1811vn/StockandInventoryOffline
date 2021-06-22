enum DocumentType{
  incoming,
  outgoing,
  //stock_taking
}
class Document{
  int id;
  String name = "";
  String description = "";
  DateTime date = DateTime.now();
  DocumentType type;
  int supplierId;
  String supplierName;
  String customerName;
  int customerId;
  int storeId;
  int quantity;

  Document();

  Document clone() {
    Document newDocument = Document();
    newDocument.name = this.name;
    newDocument.description = this.description;
    newDocument.supplierId = this.supplierId;
    newDocument.customerId = this.customerId;
    newDocument.date = this.date;
    return newDocument;
  }

  Document.map(dynamic obj) {
    this.id = obj["id"];
    this.name = obj["name"];
    this.description = obj["description"];
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
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    map["date"] = date.millisecondsSinceEpoch;
    map["type"] = type.index;
    map["supplierId"] = supplierId;
    map["customerId"] = customerId;
    map["storeId"] = storeId;
    return map;
  }
}