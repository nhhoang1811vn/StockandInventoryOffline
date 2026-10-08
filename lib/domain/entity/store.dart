import 'base_model.dart';

class Store extends BaseModel {
  Store();
  String networkId = "";
  String? file;

  Store.map(dynamic obj) {
    super.map(obj);
    this.networkId = obj["networkId"] ?? "";
    this.file = obj["file"];
  }


  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["networkId"] = networkId;
    map["file"] = file;
    return map;
  }
}
