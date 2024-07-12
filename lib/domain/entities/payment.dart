import 'package:good_manager/domain/entities/base_model.dart';

class Payment extends BaseModel {
  DateTime date = DateTime.now();
  double? amount;
  late int documentId;

  Payment();

  Payment.map(dynamic obj) {
    super.map(obj);
    this.date = DateTime.fromMillisecondsSinceEpoch(obj["date"]);
    this.amount = obj["amount"];
    this.documentId = obj["documentId"];
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["date"] = date.millisecondsSinceEpoch;
    map["amount"] = amount;
    map["documentId"] = documentId;
    return map;
  }
}
