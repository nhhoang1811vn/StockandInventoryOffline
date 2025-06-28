import 'package:flutter/widgets.dart';
import 'package:good_manager/l10n/app_localizations.dart';

enum DocumentPaidStatus {
  unpaid(0),
  partial(1),
  paid(2);
  const DocumentPaidStatus(this.value);
  final int value;
}
extension DocumentPaidStatusExtension on DocumentPaidStatus{
  String getText(BuildContext context){
    switch(this){
      case DocumentPaidStatus.unpaid:
        return AppLocalizations.of(context)!.payment_status_unpaid;
      case DocumentPaidStatus.partial:
        return AppLocalizations.of(context)!.payment_status_partial;
      case DocumentPaidStatus.paid:
        return AppLocalizations.of(context)!.payment_status_paid;
    }
  }
}
