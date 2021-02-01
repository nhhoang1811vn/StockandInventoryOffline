class Supplier{
  int id;
  String name;
  String description;

  Supplier(this.name, this.description);

  Supplier.map(dynamic obj) {
    this.name = obj["name"];
    this.description = obj["description"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["name"] = name;
    map["description"] = description;

    return map;
  }
  void setId(int id){
    this.id = id;
  }
}