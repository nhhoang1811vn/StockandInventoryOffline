import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

enum DocumentPaidStatus {
  unpaid(0),
  partial(1),
  paid(2);

  const DocumentPaidStatus(this.value);

  final int value;
}

extension DocumentPaidStatusExtension on DocumentPaidStatus {
  String getText(BuildContext context) {
    switch (this) {
      case DocumentPaidStatus.unpaid:
        return context.tr("payment_status_unpaid");
      case DocumentPaidStatus.partial:
        return context.tr("payment_status_partial");
      case DocumentPaidStatus.paid:
        return context.tr("payment_status_paid");
    }
  }
}
