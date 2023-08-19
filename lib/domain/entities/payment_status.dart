import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
enum PaymentStatus{
  UNPAID,
  PARTIAL,
  PAID
}
extension PaymentStatusExtension on PaymentStatus{
  String getTitle(BuildContext context){
    switch(this){
      case PaymentStatus.UNPAID:
        return AppLocalizations.of(context)!.payment_status_unpaid;
      case PaymentStatus.PARTIAL:
        return AppLocalizations.of(context)!.payment_status_partial;
      case PaymentStatus.PAID:
        return AppLocalizations.of(context)!.payment_status_paid;
    }
  }
}