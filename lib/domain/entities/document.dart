import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/base_model.dart';
import 'package:good_manager/domain/entities/payment_status.dart';
enum DocumentType {
  incoming,
  outgoing,
}
extension DocumentTypeExtension on DocumentType{
  String getTitle(BuildContext context){
    switch(this){
      case DocumentType.incoming:
        return AppLocalizations.of(context)!.incoming_document_text;
      case DocumentType.outgoing:
        return AppLocalizations.of(context)!.outgoing_document_text;
    }
  }
}

class Document extends BaseModel {
  DateTime date = DateTime.now();
  late DocumentType type;
  PaymentStatus paymentStatus = PaymentStatus.UNPAID;
  int? personId;
  int? storeId;


  String? personName;
  int quantity = 0;
  double amount = 0.0;
  Document();

  Document clone() {
    Document newDocument = Document();
    newDocument.name = this.name;
    newDocument.description = this.description;
    newDocument.personId = this.personId;
    newDocument.date = this.date;
    newDocument.type = this.type;
    return newDocument;
  }

  Document.map(dynamic obj) {
    super.map(obj);
    this.date = DateTime.fromMillisecondsSinceEpoch(obj["date"]);
    this.type = DocumentType.values.firstWhere((element) => element.index == obj["type"]);
    this.paymentStatus = PaymentStatus.values.firstWhere((element) => element.index == obj["paymentStatus"]);
    if (type == DocumentType.incoming){
      this.personId = obj["supplierId"];
      this.personName = obj["supplierName"];
    }else{
      this.personId = obj["customerId"];
      this.personName = obj["customerName"];
    }
    this.storeId = obj["storeId"];
    this.quantity = obj["quantity"]??0;
    this.amount = obj["amount"]??0.0;
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["date"] = date.millisecondsSinceEpoch;
    map["type"] = type.index;
    map["paymentStatus"] = paymentStatus.index;
    if (type == DocumentType.incoming){
      map["supplierId"] = personId;
    }else{
      map["customerId"] = personId;
    }
    map["storeId"] = storeId;
    return map;
  }
}