class Supplier{
  int id;
  String name = "";
  String description = "";
  String address = "";
  String email = "";
  String phone = "";
  String taxID = "";
  String bankDetail = "";

  Supplier.origin();

  Supplier.map(dynamic obj) {
    this.id = obj["id"];
    this.name = obj["supplierName"];
    this.description = obj["description"];
    this.address = obj["address"];
    this.email = obj["email"];
    this.phone = obj["phone"];
    this.taxID = obj["taxID"];
    this.bankDetail = obj["bankDetail"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["supplierName"] = name;
    map["description"] = description;
    map["address"] = address;
    map["email"] = email;
    map["phone"] = phone;
    map["taxID"] = taxID;
    map["bankDetail"] = bankDetail;

    return map;
  }
}