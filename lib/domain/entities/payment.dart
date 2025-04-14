import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/entities/customer.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/entities/supplier.dart';
import 'package:good_manager/domain/entities/wallet.dart';

enum PaymentType {
  inbound,
  outbound,
}
class Payment extends BaseModel {
  DateTime date = DateTime.now();
  double? amount;

  int? categoryId;
  int? walletId;
  int? documentId;
  int? supplierId;
  int? customerId;

  late int storeId;
  PaymentType type = PaymentType.inbound;

  PaymentCategory? category;
  Wallet? wallet;
  Document? document;
  Customer? customer;
  Supplier? supplier;
  Payment();

  Payment.map(dynamic obj) {
    super.map(obj);
    this.date = DateTime.fromMillisecondsSinceEpoch(obj["date"]);
    this.amount = obj["amount"];
    this.documentId = obj["documentId"];
    this.categoryId = obj["categoryId"];
    this.walletId = obj["walletId"];
    this.customerId = obj["customerId"];
    this.supplierId = obj["supplierId"];

    this.storeId = obj["storeId"];
    this.type = PaymentType.values.firstWhere((element) => element.index == obj["type"]);
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["date"] = date.millisecondsSinceEpoch;
    map["amount"] = amount;
    map["documentId"] = documentId;
    map["categoryId"] = categoryId;
    map["walletId"] = walletId;
    map["customerId"] = customerId;
    map["supplierId"] = supplierId;
    map["storeId"] = storeId;
    map["type"] = type.index;
    return map;
  }
}
