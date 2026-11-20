import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

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
  RE_ORDER,
  GOOD_INFO,
  SALES_BY_DATE,
  SALES_BY_ITEM,
  SALES_BY_CUSTOMER
}

extension ReportTypeExtension on ReportType {
  String getTitle(BuildContext context) {
    switch (this) {
      case ReportType.LIST_OF_GOODS:
        return context.tr("report_type_goods");
      case ReportType.LIST_OF_DOCUMENT:
        return context.tr("report_type_list_of_documents");
      case ReportType.DEBTS_BY_SUPPLIER:
        return context.tr("report_type_debt_by_supplier");
      case ReportType.DEBTS_BY_CUSTOMER:
        return context.tr("report_type_debt_by_customer");
      case ReportType.OUTBOUND_PAYMENTS:
        return context.tr("report_type_outbound_payments");
      case ReportType.INBOUND_PAYMENTS:
        return context.tr("report_type_inbound_payments");
      case ReportType.LIST_OF_WALLETS:
        return context.tr("title_report_list_of_wallet");
      case ReportType.LIST_OF_SUPPLIER_PAYMENTS:
        return context.tr("report_type_list_of_supplier_payments");
      case ReportType.LIST_OF_CUSTOMER_PAYMENTS:
        return context.tr("report_type_list_of_customer_payments");
      case ReportType.RE_ORDER:
        return context.tr("report_type_reorder");
      case ReportType.GOOD_INFO:
        return context.tr("report_type_good_info");
      case ReportType.SALES_BY_DATE:
        return context.tr("report_type_sales_by_date");
      case ReportType.SALES_BY_ITEM:
        return context.tr("report_type_sales_by_item");
      case ReportType.SALES_BY_CUSTOMER:
        return context.tr("report_type_sales_by_customer");
    }
  }
}
