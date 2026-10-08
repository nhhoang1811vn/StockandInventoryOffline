import 'dart:convert';

import 'base_model.dart';

class Group extends BaseModel {
  String? barCode;
  late int storeId;
  int? groupId;
  String? file;
  List<String> files = [];

  Group();

  Group.map(dynamic obj) {
    super.map(obj);
    this.barCode = obj["barCode"];
    this.storeId = obj["storeId"];
    this.groupId = obj["groupId"];
    this.file = obj["file"];
    if (obj["files"] != null && obj["files"].toString().isNotEmpty) {
      this.files = (jsonDecode(obj["files"]) as List<dynamic>).cast<String>();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["barCode"] = barCode;
    map["storeId"] = storeId;
    map["groupId"] = groupId;
    map["file"] = file;
    map["files"] = jsonEncode(files);
    return map;
  }

  Map<String, dynamic> toMapV2() {
    var map = super.toMap();
    map["id"] = id;
    map["barCode"] = barCode;
    map["storeId"] = storeId;
    map["groupId"] = groupId;
    map["file"] = file;
    map["files"] = jsonEncode(files);
    return map;
  }
}
