import 'package:good_manager/domain/entities/payment.dart';

import 'base_model.dart';

class PaymentCategory extends BaseModel{
  int color = 0;
  PaymentType type = PaymentType.inbound;
  PaymentCategory();
  PaymentCategory.map(dynamic obj) {
    super.map(obj);
    this.color = obj["color"];
    this.type = PaymentType.values.firstWhere((element) => element.index == obj["type"]);
  }
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["color"] = color;
    map["type"] = type.index;
    return map;
  }
}