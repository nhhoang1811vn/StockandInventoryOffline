import 'package:good_manager/domain/entities/base_model.dart';

class Store extends BaseModel {
  String description;

  Store();

  Store.map(dynamic obj) {
    this.id = obj["id"];
    this.name = obj["name"];
    this.description = obj["description"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    return map;
  }
}