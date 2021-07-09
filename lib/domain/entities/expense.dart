import 'package:good_manager/domain/entities/base_model.dart';

class Expense extends BaseModel {
  DateTime date = DateTime.now();

  Expense();

  Expense.map(dynamic obj) {
    super.map(obj);
    this.date = DateTime.fromMillisecondsSinceEpoch(obj["date"]);
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["date"] = date.millisecondsSinceEpoch;
    return map;
  }
}
