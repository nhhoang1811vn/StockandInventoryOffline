import 'base_model.dart';
class Wallet extends BaseModel{
  int color = 0;
  String number = "";
  double balance = 0.0;
  int? storeId;

  Wallet();
  Wallet.map(dynamic obj) {
    super.map(obj);
    this.color = obj["color"];
    this.storeId = obj["storeId"];
  }
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["color"] = color;
    map["storeId"] = storeId;
    return map;
  }
}