import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
enum ReportType{
  LIST_OF_GOODS,
  LIST_OF_DOCUMENT,
  DEBTS_BY_SUPPLIER,
  DEBTS_BY_CUSTOMER,
  OUTBOUND_PAYMENTS,
  INBOUND_PAYMENTS,

}
extension ReportTypeExtension on ReportType{
  String getTitle(BuildContext context){
    switch(this){
      case ReportType.LIST_OF_GOODS:
        return AppLocalizations.of(context)!.report_type_goods;
      //case ReportType.EXPENSES:
      //  return AppLocalizations.of(context)!.report_type_expenses;
      case ReportType.LIST_OF_DOCUMENT:
        return AppLocalizations.of(context)!.report_type_list_of_documents;
      case ReportType.DEBTS_BY_SUPPLIER:
        return AppLocalizations.of(context)!.report_type_debt_by_supplier;
      case ReportType.DEBTS_BY_CUSTOMER:
        return AppLocalizations.of(context)!.report_type_debt_by_customer;
      case ReportType.OUTBOUND_PAYMENTS:
        return AppLocalizations.of(context)!.title_outbound_payment;
      case ReportType.INBOUND_PAYMENTS:
        return AppLocalizations.of(context)!.title_inbound_payment;

    }
  }
}