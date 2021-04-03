class Supplier{
  int id;
  String supplierName = "";
  String description = "";
  String address = "";
  String email = "";
  String phone = "";
  String taxID = "";
  String bankDetail = "";

  Supplier.origin();

  Supplier(this.supplierName, this.description, this.address, this.email,
      this.phone, this.taxID, this.bankDetail);

  Supplier.map(dynamic obj) {
    this.id = obj["id"];
    this.supplierName = obj["supplierName"];
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
    map["supplierName"] = supplierName;
    map["description"] = description;
    map["address"] = address;
    map["email"] = email;
    map["phone"] = phone;
    map["taxID"] = taxID;
    map["bankDetail"] = bankDetail;

    return map;
  }
}