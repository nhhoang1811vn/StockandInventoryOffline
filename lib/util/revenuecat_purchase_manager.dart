import 'dart:io';

import 'package:good_manager/common/platform_support.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum RestoreResult { proActive, nothingToRestore, failed }

class RevenueCatService {
  static const _iOSApiKey = "appl_KGWoCLtajwNthduUxJssMgKdToD";
  static const _androidApiKey = "goog_CilBoRCyEYZGNZrIUNrscUJnJIJ";

  static const entitlementIdenditifer = "stockandinventory_pro";

  static final RevenueCatService _instance = RevenueCatService._internal();

  factory RevenueCatService() => _instance;

  RevenueCatService._internal();

  // RevenueCat has no Windows/desktop SDK: purchases are unavailable there.
  static Future<void> init() async {
    if (!isMobilePlatform) return;
    await Purchases.setLogLevel(LogLevel.debug);
    var apiKey = "";
    if (Platform.isAndroid) {
      apiKey = _androidApiKey;
    } else {
      apiKey = _iOSApiKey;
    }
    await Purchases.configure(PurchasesConfiguration(apiKey));
  }

  static Future<Offerings?> getOfferings() async {
    if (!isMobilePlatform) return null;
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      print("Error fetching offerings: $e");
      return null;
    }
  }

  static Future<bool> isPro() async {
    if (!isMobilePlatform) return false;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active
          .containsKey(entitlementIdenditifer);
    } catch (e) {
      print("Error checking entitlements: $e");
      return false;
    }
  }

  static Future<void> purchase(Package package) async {
    if (!isMobilePlatform) return;
    try {
      //package.storeProduct.
      await Purchases.purchase(PurchaseParams.package(package));
    } catch (e) {
      print("Purchase failed: $e");
    }
  }

  /// Asks the store for the user's past purchases and moves the entitlement to
  /// the current RevenueCat app user id.
  static Future<RestoreResult> restorePurchases() async {
    if (!isMobilePlatform) return RestoreResult.failed;
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.active
              .containsKey(entitlementIdenditifer)
          ? RestoreResult.proActive
          : RestoreResult.nothingToRestore;
    } catch (e) {
      print("Restore purchases failed: $e");
      return RestoreResult.failed;
    }
  }

  static Future<void> updateUser(String userId) async {
    if (!isMobilePlatform) return;
    try {
      await Purchases.logIn(userId);
      print("RevenueCat logged in: $userId");
    } catch (e) {
      print("RevenueCat logIn error: $e");
    }
  }

  static Future<void> logoutUser() async {
    if (!isMobilePlatform) return;
    await Purchases.logOut();
    print("RevenueCat logged out");
  }
}
