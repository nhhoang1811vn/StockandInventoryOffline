import 'package:flutter/widgets.dart';
import 'package:good_manager/l10n/app_localizations.dart';
enum HelpType{
  STORE,
  SUPPLIER_AND_CUSTOMER,
  GOODS,
  DOCUMENTS,
  PAYMENTS,
  MIN_QUAN
}
extension HelpTypeExtension on HelpType{
  String getTitle(BuildContext context){
    switch(this){
      case HelpType.STORE:
        return AppLocalizations.of(context)!.stores_title;
      case HelpType.SUPPLIER_AND_CUSTOMER:
        return AppLocalizations.of(context)!.suppliers_title;
      case HelpType.GOODS:
        return AppLocalizations.of(context)!.goods_title;
      case HelpType.DOCUMENTS:
        return AppLocalizations.of(context)!.documents_title;
      case HelpType.PAYMENTS:
        return AppLocalizations.of(context)!.payments_title;
      case HelpType.MIN_QUAN:
        return AppLocalizations.of(context)!.menu_item_minimum_quantity;
    }
  }
}

