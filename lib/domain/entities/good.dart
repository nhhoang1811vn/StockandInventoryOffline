import 'dart:convert';

import 'package:good_manager/domain/entities/base_model.dart';

class Good extends BaseModel {
  String? barCode;
  late int storeId;
  int? groupId;

  double? purchasePrice;
  double? salePrice;
  List<String> files = [];

  //todo take care quantity here, it mapping manual
  double quantity = 0;
  Good();

  Good.map(dynamic obj) {
    super.map(obj);
    this.barCode = obj["barCode"];
    this.purchasePrice = obj["purchasePrice"];
    this.salePrice = obj["salePrice"];
    this.storeId = obj["storeId"];
    this.groupId = obj["groupId"];
    this.files = (jsonDecode(obj["files"]) as List<dynamic>).cast<String>();
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["barCode"] = barCode;
    map["purchasePrice"] = purchasePrice;
    map["salePrice"] = salePrice;
    map["storeId"] = storeId;
    map["groupId"] = groupId;
    map["files"] = jsonEncode(files);
    return map;
  }
}