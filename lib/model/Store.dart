class Store{
  int id;
  String name;
  String description;

  Store(this.name, this.description);

  Store.map(dynamic obj) {
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