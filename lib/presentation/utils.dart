//import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/pages.dart';

import '../domain/entity/entity.dart';

class Utils {
  static DocumentPaidStatus getStatus(Document document) {
    var amount = document.amount;
    var paid = document.paid;
    if (amount == 0.0 || paid >= amount) {
      return DocumentPaidStatus.paid;
    } else if (paid == 0.0) {
      return DocumentPaidStatus.unpaid;
    } else {
      return DocumentPaidStatus.partial;
    }
  }

  static Future<String?> scanBarcode(BuildContext context) async {
    Object? result =
        await Navigator.of(context).pushNamed(Pages.barcode_scanner);
    return result?.toString();
  }
}
