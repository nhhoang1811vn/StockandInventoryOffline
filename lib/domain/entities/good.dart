import 'dart:convert';

import 'package:good_manager/domain/entities/base_model.dart';

class Good extends BaseModel {
  int id;
  String name;
  String description;
  String barCode;
  int storeId;
  int groupId;
  List<String> files = [];

  int quantity;
  int pendingQuantity = 0;

  Good();

  Good.map(dynamic obj) {
    this.id = obj["id"];
    this.name = obj["name"];
    this.description = obj["description"];
    this.barCode = obj["barCode"];
    this.storeId = obj["storeId"];
    this.groupId = obj["groupId"];
    this.files = (jsonDecode(obj["files"]) as List<dynamic>).cast<String>();
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    map["barCode"] = barCode;
    map["storeId"] = storeId;
    map["groupId"] = groupId;
    map["files"] = jsonEncode(files);
    return map;
  }
}