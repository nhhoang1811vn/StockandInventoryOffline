import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
enum SearchDocumentsType {
  byName(0),
  byDescription(1),
  byCustomerSupplier(2);
  const SearchDocumentsType(this.value);
  final int value;
}
extension SearchDocumentsTypeExtension on SearchDocumentsType{
  String getText(BuildContext context){
    switch(this){
      case SearchDocumentsType.byName:
        return AppLocalizations.of(context)!.search_documents_type_by_name;
      case SearchDocumentsType.byDescription:
        return AppLocalizations.of(context)!.search_documents_type_by_description;
      case SearchDocumentsType.byCustomerSupplier:
        return AppLocalizations.of(context)!.search_documents_type_by_customer_supplier;
    }
  }
}
