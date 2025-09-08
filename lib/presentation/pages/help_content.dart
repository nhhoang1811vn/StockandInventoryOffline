import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

enum HelpType {
  STORE,
  SUPPLIER_AND_CUSTOMER,
  GOODS,
  DOCUMENTS,
  PAYMENTS,
  MIN_QUAN
}

extension HelpTypeExtension on HelpType {
  String getTitle(BuildContext context) {
    switch (this) {
      case HelpType.STORE:
        return context.tr("stores");
      case HelpType.SUPPLIER_AND_CUSTOMER:
        return context.tr("suppliers");
      case HelpType.GOODS:
        return context.tr("goods");
      case HelpType.DOCUMENTS:
        return context.tr("documents");
      case HelpType.PAYMENTS:
        return context.tr("payments_title");
      case HelpType.MIN_QUAN:
        return context.tr("menu_item_minimum_quantity");
    }
  }
}
