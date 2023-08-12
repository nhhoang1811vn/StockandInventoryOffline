import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
enum ReportType{
  //DEBTS_BY_CUSTOMER,
  //DEBTS_BY_SUPPLIER,
  EXPENSES,
  LIST_OF_DOCUMENT,
  //LIST_OF_TRANSACTION,
  //PROFITS_AND_LOSSES,

}
extension ReportTypeExtension on ReportType{
  String getTitle(BuildContext context){
    switch(this){
      case ReportType.EXPENSES:
        return AppLocalizations.of(context)!.report_type_expenses;
      case ReportType.LIST_OF_DOCUMENT:
        return AppLocalizations.of(context)!.report_type_list_of_documents;
    }
  }
}