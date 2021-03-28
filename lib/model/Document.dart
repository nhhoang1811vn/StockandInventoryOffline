enum DocumentType{
  incoming,
  outgoing,
  stock_taking
}
class Document{
  int id;
  String name = "";
  String description = "";
  DateTime date = DateTime.now();
  DocumentType type;
  int supplierId;
  int customerId;
  int storeId;
  int quantity;
  Document();


  Document.map(dynamic obj){
    this.id = obj["id"];
    this.name = obj["name"];
    this.description = obj["description"];
    this.date = DateTime.fromMillisecondsSinceEpoch(obj["date"]);
    //this.type = obj["type"];
    DocumentType.values.forEach((element) {
      if (obj["type"] == element.index){
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