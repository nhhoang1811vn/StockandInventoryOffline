import 'package:intl/intl.dart';

class Config {
  static String supportEmail = "nhhoang1811vn@gmail.com";
  static DateTime minTime = DateTime(2000, 1, 1);
  static DateTime maxTime = DateTime(2100, 1, 1);
  static NumberFormat currencyFormat =
      NumberFormat.currency(locale: "en_US", symbol: "", decimalDigits: 0);
  static NumberFormat simpleCurrencyFormat =
      NumberFormat.decimalPattern("en_US");
}
