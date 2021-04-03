class Good{
  int id;
  String name;
  String description;
  String barCode;
  int storeId;
  int groupId;

  int quantity;

  Good();


  Good.map(dynamic obj){
    this.id = obj["id"];
    this.name = obj["name"];
    this.description = obj["description"];
    this.barCode = obj["barCode"];
    this.storeId = obj["storeId"];
    this.groupId = obj["groupId"];

    this.quantity = obj["quantity"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    map["barCode"] = barCode;
    map["storeId"] = storeId;
    map["groupId"] = groupId;

    //map["quantity"] = quantity;
    return map;
  }
}