import 'package:good_manager/domain/entities/base_model.dart';

class Group extends BaseModel {
  String barCode = "";
  int storeId;
  int groupId;

  Group();
  Group.map(dynamic obj) {
    super.map(obj);
    this.barCode = obj["barCode"];
    this.storeId = obj["storeId"];
    this.groupId = obj["groupId"];
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["barCode"] = barCode;
    map["storeId"] = storeId;
    map["groupId"] = groupId;
    return map;
  }
}