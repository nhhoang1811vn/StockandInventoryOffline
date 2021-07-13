import 'package:good_manager/domain/entities/base_model.dart';

class Store extends BaseModel {
  Store();

  Store.map(dynamic obj) {
    super.map(obj);
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}