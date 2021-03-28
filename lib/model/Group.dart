class Group{
  int id;
  String name = "";
  String description = "";
  String barCode = "";
  int storeId;
  int groupId;

  Group();

  Group.map(dynamic obj){
    this.id = obj["id"];
    this.name = obj["name"];
    this.description = obj["description"];
    this.barCode = obj["barCode"];
    this.storeId = obj["storeId"];
    this.groupId = obj["groupId"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["name"] = name;
    map["description"] = description;
    map["barCode"] = barCode;
    map["storeId"] = storeId;
    map["groupId"] = groupId;
    return map;
  }
}