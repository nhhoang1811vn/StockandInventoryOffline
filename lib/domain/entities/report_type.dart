import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
enum ReportType{
  EXPENSES,
  LIST_OF_DOCUMENT,
  DEBTS_BY_SUPPLIER,
  DEBTS_BY_CUSTOMER,
}
extension ReportTypeExtension on ReportType{
  String getTitle(BuildContext context){
    switch(this){
      case ReportType.EXPENSES:
        return AppLocalizations.of(context)!.report_type_expenses;
      case ReportType.LIST_OF_DOCUMENT:
        return AppLocalizations.of(context)!.report_type_list_of_documents;
      case ReportType.DEBTS_BY_SUPPLIER:
        return AppLocalizations.of(context)!.report_type_debt_by_supplier;
      case ReportType.DEBTS_BY_CUSTOMER:
        return AppLocalizations.of(context)!.report_type_debt_by_customer;
    }
  }
}