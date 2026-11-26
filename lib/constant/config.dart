import 'package:intl/intl.dart';

class Config {
  static String appName = "StockandInventory";
  static String supportEmail = "nhhoang1811vn@gmail.com";
  static DateTime minTime = DateTime(2000, 1, 1);
  static DateTime maxTime = DateTime(2100, 1, 1);
  //static NumberFormat currencyFormat =
      //NumberFormat.currency(symbol: AppSettings.currency.symbol, decimalDigits: 0);
  static NumberFormat simpleCurrencyFormat = NumberFormat.decimalPattern("en_US");

  static const String iOSAppStoreId = "6670546293";
  static String iOSStoreLink = "https://apps.apple.com/us/app/stock-and-inventory/id6670546293";
  static String androidStoreLink = "https://play.google.com/store/apps/details?id=com.steam.goodmanagerflutter";

  static const String onlineAppAndroidUrl =
      "https://play.google.com/store/apps/details?id=com.steam.goodmanagerflutteronline";
  static const String onlineAppIosUrl =
      "https://apps.apple.com/us/app/stock-inventory-online/id6761761103";
  static const String windowsReleaseUrl =
      "https://github.com/nhhoang1811vn/StockandInventoryOffline/releases/tag/v1.0.93w";
  static const String windowsGuideUrl =
      "https://github.com/nhhoang1811vn/StockandInventoryOffline";

  static String termOfUseUrl = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/";
  static String privacyPolicyUrl = "https://www.freeprivacypolicy.com/live/441fa2be-af36-49e4-8dd2-880a7d5f19c0";
}
