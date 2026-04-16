import 'package:good_manager/domain/entity/entity.dart';

class StoreRealtimeEntity {
  late int localId;
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
  List<DocumentTransaction> documentTransactions = [];

  List<Wallet> wallets = [];
  List<PaymentCategory> paymentCategories = [];
  List<Payment> payments = [];

  List<MemberEntity> members = [];


  Map<String, dynamic> toJson() {
    return {
      "localId": localId,
      "networkId": networkId,
      "name": name,
      "description": description,
      "createdDate": createdDate.toIso8601String(),
      "updatedDate": updatedDate.toIso8601String(),
       "suppliers" : {
         for (var s in suppliers) s.id.toString() : s.toMap(includeId: true)
       },
      "customers" : {
        for (var c in customers) c.id.toString() : c.toMap(includeId: true)
      },
      "groups" : {
        for (var group in groups) group.id.toString() : group.toMap(includeId: true)
      },
      // "goods": goods.map((e) => e.toMap(includeId: true)).toList(),
      // "documents": documents.map((e) => e.toMap(includeId: true)).toList(),
      // "documentTransactions": documentTransactions.map((e) => e.toMap()).toList(),
      // "wallets": wallets.map((e) => e.toMap(includeId: true)).toList(),
       "paymentCategories": {
         for (var cat in paymentCategories) cat.id.toString() : cat.toMap(includeId: true)
       },
      // "payments": payments.map((e) => e.toMap(includeId: true)).toList(),
      // "members" : members.map((e) => e.toJson()).toList()
    };
  }
}
class MemberEntity {
  String email = "";
  String role = "";

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "role": role
    };
  }
}