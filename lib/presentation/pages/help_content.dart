import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
enum HelpType{
  STORE,
  SUPPLIER_AND_CUSTOMER,
  GOODS,
  DOCUMENTS,
  EXPENSE,
  PAYMENTS,
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
      case HelpType.EXPENSE:
        return AppLocalizations.of(context)!.expenses_title;
      case HelpType.PAYMENTS:
        return AppLocalizations.of(context)!.payments_title;
    }
  }
}

