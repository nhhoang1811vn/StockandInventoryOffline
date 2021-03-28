class DocumentTransaction{
  int id;
  int documentId;
  int goodId;
  int quantity;
  DocumentTransaction();


  DocumentTransaction.map(dynamic obj){
    this.id = obj["id"];
    this.documentId = obj["documentId"];
    this.goodId = obj["goodId"];
    this.quantity = obj["quantity"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["documentId"] = documentId;
    map["goodId"] = goodId;
    map["quantity"] = quantity;
    return map;
  }
}