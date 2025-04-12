import 'package:good_manager/domain/entities/payment.dart';

import 'base_model.dart';

class PaymentCategory extends BaseModel{
  String icon = "😄";
  PaymentType type = PaymentType.inbound;
  PaymentCategory();
  PaymentCategory.map(dynamic obj) {
    super.map(obj);
    this.icon = obj["icon"];
    this.type = PaymentType.values.firstWhere((element) => element.index == obj["type"]);
  }
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["icon"] = icon;
    map["type"] = type.index;
    return map;
  }
}