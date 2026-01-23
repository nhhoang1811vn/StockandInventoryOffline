import 'base_model.dart';

class Store extends BaseModel {
  Store();
  String networkId = "";

  Store.map(dynamic obj) {
    super.map(obj);
    this.networkId = obj["networkId"] ?? "";
  }


  @override
  Map<String, dynamic> toMap({bool includeId = false}) {
    var map = super.toMap();
    map["networkId"] = networkId;
    return map;
  }
}
