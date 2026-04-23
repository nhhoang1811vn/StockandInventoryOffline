import 'package:good_manager/domain/entity/entity.dart';

class StoreRealtimeEntity {
  String networkId = "";
  String name = "";
  String description = "";
  late DateTime createdDate;
  late DateTime updatedDate;

  List<Supplier> suppliers = [];
  List<Customer> customers = [];
  List<Group> groups = [];
  List<Good> goods = [];
  List<Document> documents = [];
  Map<String, List<DocumentTransaction>> documentTransactions = {};

  List<Wallet> wallets = [];
  List<PaymentCategory> paymentCategories = [];
  List<Payment> payments = [];

  Map<String, dynamic> toJson() {
    return {
      "networkId": networkId,
      "name": name,
      "description": description,
      "createdDate": createdDate.millisecondsSinceEpoch,
      "updatedDate": updatedDate.millisecondsSinceEpoch,
      "suppliers": {
        for (var item in suppliers) "${item.id}" : item.toMapV2()
      },
      "customers": {
        for (var item in customers) "${item.id}": item.toMapV2()
      },
      "groups": {for (var item in groups) "${item.id}": item.toMapV2()},
      "goods": {for (var item in goods) item.id.toString(): item.toMapV2()},
      "documents": {
        for (var item in documents) item.id.toString(): item.toMapV2()
      },
      "transactionByDocument": {
        for (var entry in documentTransactions.entries)
          entry.key: {
            for (var tx in entry.value) "${tx.id}": tx.toMapV2()
          }
      },

      "wallets": {
        for (var item in wallets) "${item.id}": item.toMapV2()
      },
      "paymentCategories": {
        for (var item in paymentCategories) "${item.id}": item.toMapV2()
      },
      "payments": {
        for (var item in payments) "${item.id}": item.toMapV2()
      },
    };
  }
}
