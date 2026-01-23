class BaseModel {
  int? id;
  String name = "";
  String description = "";
  late DateTime createdDate;
  late DateTime updatedDate;

  BaseModel();

  void map(dynamic obj) {
    this.id = obj["id"];
    this.name = obj["name"];
    this.description = obj["description"];
    this.createdDate = DateTime.fromMillisecondsSinceEpoch(obj["createdDate"]);
    this.updatedDate = DateTime.fromMillisecondsSinceEpoch(obj["updatedDate"]);
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    var map = new Map<String, dynamic>();
    if (includeId) {
      map["id"] = id;
    }
    map["name"] = name;
    map["description"] = description;
    map["createdDate"] = createdDate.millisecondsSinceEpoch;
    map["updatedDate"] = updatedDate.millisecondsSinceEpoch;
    return map;
  }
}
