import 'dart:convert';

import 'package:good_manager/domain/entities/base_model.dart';

class Good extends BaseModel {
  String? barCode;
  late int storeId;
  String directory = "/";
  List<String> files = [];

  int quantity = 0;
  int pendingQuantity = 0;

  Good();

  Good.map(dynamic obj) {
    super.map(obj);
    this.barCode = obj["barCode"];
    this.storeId = obj["storeId"];
    this.directory = obj["directory"];
    this.files = (jsonDecode(obj["files"]) as List<dynamic>).cast<String>();
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["barCode"] = barCode;
    map["storeId"] = storeId;
    map["directory"] = directory;
    map["files"] = jsonEncode(files);
    return map;
  }
}