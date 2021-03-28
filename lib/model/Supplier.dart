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
  Supplier(this.name,
      this.description,
      this.address,
      this.email,
      this.phone,
      this.taxID,
      this.bankDetail);


  Supplier.map(dynamic obj) {
    this.name = obj["name"];
    this.description = obj["description"];
    this.address = obj["address"];
    this.email = obj["email"];
    this.phone = obj["phone"];
    this.taxID = obj["taxID"];
    this.bankDetail = obj["bankDetail"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["name"] = name;
    map["description"] = description;
    map["address"] = address;
    map["email"] = email;
    map["phone"] = phone;
    map["taxID"] = taxID;
    map["bankDetail"] = bankDetail;

    return map;
  }
  void setId(int id){
    this.id = id;
  }
}