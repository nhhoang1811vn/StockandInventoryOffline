import 'package:flutter/widgets.dart';
import 'package:good_manager/l10n/app_localizations.dart';

enum ReportType {
  LIST_OF_GOODS,
  LIST_OF_DOCUMENT,
  DEBTS_BY_SUPPLIER,
  DEBTS_BY_CUSTOMER,
  INBOUND_PAYMENTS,
  OUTBOUND_PAYMENTS,
  LIST_OF_WALLETS,
  LIST_OF_CUSTOMER_PAYMENTS,
  LIST_OF_SUPPLIER_PAYMENTS,
  RE_ORDER
}

extension ReportTypeExtension on ReportType {
  String getTitle(BuildContext context) {
    switch (this) {
      case ReportType.LIST_OF_GOODS:
        return AppLocalizations.of(context)!.report_type_goods;
      case ReportType.LIST_OF_DOCUMENT:
        return AppLocalizations.of(context)!.report_type_list_of_documents;
      case ReportType.DEBTS_BY_SUPPLIER:
        return AppLocalizations.of(context)!.report_type_debt_by_supplier;
      case ReportType.DEBTS_BY_CUSTOMER:
        return AppLocalizations.of(context)!.report_type_debt_by_customer;
      case ReportType.OUTBOUND_PAYMENTS:
        return AppLocalizations.of(context)!.report_type_outbound_payments;
      case ReportType.INBOUND_PAYMENTS:
        return AppLocalizations.of(context)!.report_type_inbound_payments;
      case ReportType.LIST_OF_WALLETS:
        return AppLocalizations.of(context)!.title_report_list_of_wallet;
      case ReportType.LIST_OF_SUPPLIER_PAYMENTS:
        return AppLocalizations.of(context)!
            .report_type_list_of_supplier_payments;
      case ReportType.LIST_OF_CUSTOMER_PAYMENTS:
        return AppLocalizations.of(context)!
            .report_type_list_of_customer_payments;
      case ReportType.RE_ORDER:
        return AppLocalizations.of(context)!.report_type_reorder;
    }
  }
}
