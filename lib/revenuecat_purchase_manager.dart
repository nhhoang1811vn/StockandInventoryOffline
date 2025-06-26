import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static const _iOSApiKey = "appl_KGWoCLtajwNthduUxJssMgKdToD";
  static const _androidApiKey = "goog_CilBoRCyEYZGNZrIUNrscUJnJIJ";

  static const entitlementIdenditifer = "stockandinventory_pro";

  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    var apiKey = "";
    if (Platform.isAndroid){
      apiKey = _androidApiKey;
    }else{
      apiKey = _iOSApiKey;
    }
    await Purchases.configure(PurchasesConfiguration(apiKey));
  }
  static Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      print("Error fetching offerings: $e");
      return null;
    }
  }
  static Future<bool> isPro() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey(entitlementIdenditifer);
    } catch (e) {
      print("Error checking entitlements: $e");
      return false;
    }
  }
  static Future<void> purchase(Package package) async {
    try {
      //package.storeProduct.
      await Purchases.purchasePackage(package);
    } catch (e) {
      print("Purchase failed: $e");
    }
  }

  static Future<void> updateUser(String userId) async {
    try {
      await Purchases.logIn(userId);
      print("RevenueCat logged in: $userId");
    } catch (e) {
      print("RevenueCat logIn error: $e");
    }
  }

  static Future<void> logoutUser() async {
    await Purchases.logOut();
    print("RevenueCat logged out");
  }
}
