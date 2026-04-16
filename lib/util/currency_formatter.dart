import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:good_manager/models/currency.dart';
import 'package:intl/intl.dart';

import '../data/app_settings.dart';
//import '../settings/app_settings.dart';

class CurrencyFormatter {
  static String format(BuildContext context, num value) {
    //final locale = context.locale.toString();
    final formatter = NumberFormat.currency(
      locale: "en-US",
      symbol: AppSettings.currency.symbol,
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
}