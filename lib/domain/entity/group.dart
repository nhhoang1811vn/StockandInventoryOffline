import 'dart:convert';

import 'base_model.dart';

class Group extends BaseModel {
  String? barCode;
  late int storeId;
  int? groupId;
  List<String> files = [];

  Group();

  Group.map(dynamic obj) {
    super.map(obj);
    this.barCode = obj["barCode"];
    this.storeId = obj["storeId"];
    this.groupId = obj["groupId"];
    this.files = (jsonDecode(obj["files"]) as List<dynamic>).cast<String>();
  }

  @override
  Map<String, dynamic> toMap({bool includeId = false}) {
    var map = super.toMap();
    map["barCode"] = barCode;
    map["storeId"] = storeId;
    map["groupId"] = groupId;
    map["files"] = jsonEncode(files);
    return map;
  }
}
