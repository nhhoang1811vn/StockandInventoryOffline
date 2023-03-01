import 'package:good_manager/domain/entities/base_model.dart';

class Group extends BaseModel {
  String barCode = "";
  int storeId;
  String directory;

  Group();
  Group.map(dynamic obj) {
    super.map(obj);
    this.barCode = obj["barCode"];
    this.storeId = obj["storeId"];
    this.directory = obj["directory"];
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["barCode"] = barCode;
    map["storeId"] = storeId;
    map["directory"] = directory;
    return map;
  }
}