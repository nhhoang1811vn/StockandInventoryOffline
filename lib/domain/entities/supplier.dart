import 'package:good_manager/domain/entities/base_model.dart';

class Supplier extends BaseModel {
  String description = "";
  String address = "";
  String email = "";
  String phone = "";
  String taxID = "";
  String bankDetail = "";
  int storeId;

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
}