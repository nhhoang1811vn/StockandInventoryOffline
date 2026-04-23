import 'base_model.dart';

class Supplier extends BaseModel {
  String address = "";
  String email = "";
  String phone = "";
  String taxID = "";
  String bankDetail = "";
  late int storeId;
  int numberDocument = 0;

  Supplier();

  Supplier.map(dynamic obj) {
    super.map(obj);
    this.address = obj["address"];
    this.email = obj["email"];
    this.phone = obj["phone"];
    this.taxID = obj["taxID"];
    this.bankDetail = obj["bankDetail"];
    this.storeId = obj["storeId"];
  }


  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["address"] = address;
    map["email"] = email;
    map["phone"] = phone;
    map["taxID"] = taxID;
    map["bankDetail"] = bankDetail;
    map["storeId"] = storeId;
    return map;
  }

  Map<String, dynamic> toMapV2() {
    var map = super.toMap();
    map["id"] = id;
    map["address"] = address;
    map["email"] = email;
    map["phone"] = phone;
    map["taxID"] = taxID;
    map["bankDetail"] = bankDetail;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Supplier && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
