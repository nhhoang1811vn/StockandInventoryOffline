import 'package:good_manager/domain/entities/base_model.dart';

class Expense extends BaseModel {
  DateTime date = DateTime.now();
  double amount = 0.0;
  int storeId;

  Expense();

  Expense.map(dynamic obj) {
    super.map(obj);
    this.date = DateTime.fromMillisecondsSinceEpoch(obj["date"]);
    this.amount = obj["amount"];
    this.storeId = obj["storeId"];
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["date"] = date.millisecondsSinceEpoch;
    map["amount"] = amount;
    map["storeId"] = storeId;
    return map;
  }
}
