import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/base_model.dart';
enum DocumentType {
  incoming,
  outgoing,
}
extension DocumentTypeExtension on DocumentType{
  String getTitle(BuildContext context){
    switch(this){
      case DocumentType.incoming:
        return AppLocalizations.of(context)!.document_list_incoming_name;
      case DocumentType.outgoing:
        return AppLocalizations.of(context)!.document_list_outgoing_name;
    }
  }
}

class Document extends BaseModel {
  DateTime date = DateTime.now();
  late DocumentType type;
  int? personId;
  String? personName;

  int? storeId;
  int quantity = 0;

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
    DocumentType.values.forEach((element) {
      if (obj["type"] == element.index) {
        this.type = element;
        return;
      }
    });
    if (type == DocumentType.incoming){
      this.personId = obj["supplierId"];
    }else{
      this.personId = obj["customerId"];
    }
    this.storeId = obj["storeId"];
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["date"] = date.millisecondsSinceEpoch;
    map["type"] = type.index;
    if (type == DocumentType.incoming){
      map["supplierId"] = personId;
    }else{
      map["customerId"] = personId;
    }
    map["storeId"] = storeId;
    return map;
  }
}