import 'base_model.dart';
import 'payment.dart';

class PaymentCategory extends BaseModel {
  String icon = "🏠";
  PaymentType type = PaymentType.inbound;

  PaymentCategory();

  PaymentCategory.map(dynamic obj) {
    super.map(obj);
    this.icon = obj["icon"];
    this.type = PaymentType.values
        .firstWhere((element) => element.index == obj["type"]);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["icon"] = icon;
    map["type"] = type.index;
    return map;
  }

  Map<String, dynamic> toMapV2() {
    var map = super.toMap();
    map["id"] = id;
    map["icon"] = icon;
    map["type"] = type.index;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
