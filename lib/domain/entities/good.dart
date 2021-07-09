import 'dart:convert';

import 'package:good_manager/domain/entities/base_model.dart';

class Good extends BaseModel {
  String avatar = "";
  String barCode;
  int storeId;
  int groupId;
  List<String> files = [];

  int quantity;
  int pendingQuantity = 0;

  Good();

  Good.map(dynamic obj) {
    super.map(obj);
    this.avatar = obj["avatar"];
    this.barCode = obj["barCode"];
    this.storeId = obj["storeId"];
    this.groupId = obj["groupId"];
    this.files = (jsonDecode(obj["files"]) as List<dynamic>).cast<String>();
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["avatar"] = avatar;
    map["barCode"] = barCode;
    map["storeId"] = storeId;
    map["groupId"] = groupId;
    map["files"] = jsonEncode(files);
    return map;
  }
}