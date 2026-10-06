import 'base_model.dart';

class Customer extends BaseModel {
  String address = "";
  String email = "";
  String phone = "";
  String taxID = "";
  String bankDetail = "";
  String? file;
  late int storeId;

  int numberDocument = 0;

  Customer();

  Customer.map(dynamic obj) {
    super.map(obj);
    this.address = obj["address"];
    this.email = obj["email"];
    this.phone = obj["phone"];
    this.taxID = obj["taxID"];
    this.bankDetail = obj["bankDetail"];
    this.file = obj["file"];
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
    map["file"] = file;
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
    map["file"] = file;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
