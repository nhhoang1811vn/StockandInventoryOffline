import 'dart:typed_data';

import 'base_model.dart';

class Good extends BaseModel {
  String? barCode;
  late int storeId;
  int? groupId;

  double? purchasePrice;
  double? salePrice;

  double? minQuantity;

  //todo take care quantity here, it mapping manual
  List<Uint8List> files = [];
  double quantity = 0;

  Good();

  Good.map(dynamic obj) {
    super.map(obj);
    this.barCode = obj["barCode"];
    this.purchasePrice = obj["purchasePrice"];
    this.salePrice = obj["salePrice"];
    this.storeId = obj["storeId"];
    this.groupId = obj["groupId"];
    this.minQuantity = obj["minQuantity"];
  }

  @override
  Map<String, dynamic> toMap({bool includeId = false}) {
    var map = super.toMap();
    map["barCode"] = barCode;
    map["purchasePrice"] = purchasePrice;
    map["salePrice"] = salePrice;
    map["storeId"] = storeId;
    map["groupId"] = groupId;
    map["minQuantity"] = minQuantity;
    return map;
  }
}
