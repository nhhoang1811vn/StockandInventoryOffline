import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../common/storage/storage.dart';
import '../domain/entity/entity.dart';
import '../models/app_language.dart';
import '../models/app_theme.dart';
import '../models/currency.dart';

class AppSettings {
  static const Color incomingDocumentColor = Colors.red;
  static const Color outgoingDocumentColor = Colors.green;

  AppSettings._();

  static late Storage _storage;

  static const String InitSettings = "InitSettings3";
  static const String BarcodeScannerBatchScanMode =
      "BarcodeScannerBatchScanMode";
  static const String BarcodeScannerBatchScanDelayMs =
      "BarcodeScannerBatchScanDelayMs";
  static const String BarcodeScannerEnableBeep = "BarcodeScannerEnableBeep";
  static const String BarcodeScannerEnableVibrate =
      "BarcodeScannerEnableVibrate";

  static const String _imageSizeKey = "ImageSize";
  static const String _showCropWindowKey = "ShowCropWindow";

  static const String LanguageCode = "LanguageCode";

  static const String AutoDocumentName = "AutoDocumentName";
  static const String EnablePasscodeKey = "EnablePasscode";
  static const String UserPasscodeKey = "UserPasscode";
  static const _myCompanyKey = 'my_company';
  static const _minimumQuantitySettingsKey = 'minimumQuantitySettings';
  static const _suppliersSettingKey = "SuppliersSetting";
  static const _customersSettingKey = "CustomersSetting";
  static const _goodsSettingKey = "GoodsSetting";
  static const _documentsSettingKey = "DocumentsSetting3";
  static const _storesSettingKey = "StoresSetting";
  static const String _saveDocumentSettingKey = "SaveDocumentSetting";
  static const String _PaymentsSettingKey = "PaymentsSetting5";

  static const String _incomingDocumentColorKey = "_incomingDocumentColorKey";
  static const String _outgoingDocumentColorKey = "_outgoingDocumentColorKey";

  static const String _SavePaymentLastSelectedWalletIdKey =
      "SavePaymentLastSelectedWalletId";
  static const String _SelectedStoreIdKey = "SelectedStoreId";
  static const String _AutoDocumentNameKey = "AutoDocumentName";
  static const String _SelectedStoreNameKey = "SelectedStoreName";

  static const _keyAppTheme = "_keyAppTheme";
  static const _keyAppLanguage = "_keyAppLanguage";
  static const _keyCurrency = "_keyCurrency";

  static late Box _box;
  static bool _isPro = false;

  // static Future<bool> init(Storage storage) async {
  //   try {
  //     _storage = storage;
  //     if (_storage.getBool(InitSettings) == null) {
  //       _storage.setInt(
  //         BarcodeScannerBatchScanMode,
  //         BatchModeScan.MANUAL.value,
  //       );
  //       _storage.setBool(BarcodeScannerEnableBeep, true);
  //       _storage.setBool(BarcodeScannerEnableVibrate, true);
  //       _storage.setBool(InitSettings, true);
  //     }
  //     _isPro = await RevenueCatService.isPro();
  //     return true;
  //   } catch (error) {
  //     return false;
  //   }
  // }
  static Future<bool> initialize(Storage storage) async {
    try {
      _storage = storage;
      if (_storage.getBool(InitSettings) == null) {
        _storage.setInt(
          BarcodeScannerBatchScanMode,
          BatchModeScan.MANUAL.value,
        );
        _storage.setBool(BarcodeScannerEnableBeep, true);
        _storage.setBool(BarcodeScannerEnableVibrate, true);
        _storage.setBool(InitSettings, true);
      }
      Hive.registerAdapter(AppThemeAdapter());
      Hive.registerAdapter(AppLanguageAdapter());
      Hive.registerAdapter(CurrencyAdapter());
      _box = await Hive.openBox('settings');
      return true;
    } catch (error) {
      return false;
    }
  }

  static void setLanguageCode(String value) {
    _storage.setString(LanguageCode, value);
  }

  static String getLanguageCode() {
    return _storage.getString(LanguageCode) ?? "en";
  }

  static void setBarcodeScannerEnableBeep(bool value) {
    _storage.setBool(BarcodeScannerEnableBeep, value);
  }

  static bool getBarcodeScannerEnableBeep() {
    return _storage.getBool(BarcodeScannerEnableBeep)!;
  }

  static void setBarcodeScannerEnableVibrate(bool value) {
    _storage.setBool(BarcodeScannerEnableVibrate, value);
  }

  static bool getBarcodeScannerEnableVibrate() {
    return _storage.getBool(BarcodeScannerEnableVibrate)!;
  }

  static BatchModeScan getBatchModeScan() {
    int value = _storage.getInt(BarcodeScannerBatchScanMode)!;
    if (value == BatchModeScan.MANUAL.value) {
      return BatchModeScan.MANUAL;
    } else {
      return BatchModeScan.AUTO;
    }
  }

  static void setBatchModeScan(BatchModeScan mode) {
    _storage.setInt(BarcodeScannerBatchScanMode, mode.value);
  }

  static const int defaultBatchScanDelayMs = 2000;

  static int getBatchScanDelayMs() {
    return _storage.getInt(BarcodeScannerBatchScanDelayMs) ??
        defaultBatchScanDelayMs;
  }

  static void setBatchScanDelayMs(int value) {
    _storage.setInt(BarcodeScannerBatchScanDelayMs, value);
  }

  static const int minImageSize = 256;
  static const int maxImageSize = 2048;
  static const int defaultImageSize = 512;

  static int clampImageSize(int value) =>
      value.clamp(minImageSize, maxImageSize);

  /// Returns the size only when [input] is a whole number inside
  /// [minImageSize]..[maxImageSize]; otherwise null.
  static int? parseImageSize(String? input) {
    final value = int.tryParse(input?.trim() ?? '');
    if (value == null || value < minImageSize || value > maxImageSize) {
      return null;
    }
    return value;
  }

  static int getImageSize() {
    return clampImageSize(_storage.getInt(_imageSizeKey) ?? defaultImageSize);
  }

  static void setImageSize(int value) {
    _storage.setInt(_imageSizeKey, clampImageSize(value));
  }

  static bool getShowCropWindow() {
    return _storage.getBool(_showCropWindowKey) ?? true;
  }

  static void setShowCropWindow(bool value) {
    _storage.setBool(_showCropWindowKey, value);
  }

  static void setEnablePasscode(bool value) {
    _storage.setBool(EnablePasscodeKey, value);
  }

  static bool getEnablePasscode() {
    return _storage.getBool(EnablePasscodeKey) ?? false;
  }

  static void setPasscode(String passcode) {
    _storage.setString(UserPasscodeKey, passcode);
  }

  static String getPasscode() {
    return _storage.getString(UserPasscodeKey) ?? "";
  }

  static MyCompany getMyCompany() {
    final jsonString = _storage.getString(_myCompanyKey);
    if (jsonString == null)
      return MyCompany(
        companyName: "",
        address: "",
        email: "",
        phone: "",
        taxId: "",
        bankDetails: "",
      );
    final jsonMap = jsonDecode(jsonString);
    return MyCompany.fromJson(jsonMap);
  }

  static void setMyCompany(MyCompany obj) {
    final jsonString = jsonEncode(obj.toJson());
    _storage.setString(_myCompanyKey, jsonString);
  }

  static MinimumQuantitySettings getMinimumQuantitySettings() {
    final jsonString = _storage.getString(_minimumQuantitySettingsKey);
    if (jsonString == null)
      return MinimumQuantitySettings(
        showInList: true,
        showInItem: true,
        color: Colors.red.toARGB32(),
        showAlert: true,
      );
    final jsonMap = jsonDecode(jsonString);
    return MinimumQuantitySettings.fromJson(jsonMap);
  }

  static void setMinimumQuantitySettings(MinimumQuantitySettings obj) {
    final jsonString = jsonEncode(obj.toJson());
    _storage.setString(_minimumQuantitySettingsKey, jsonString);
  }

  static SuppliersSetting getSuppliersSetting() {
    final jsonString = _storage.getString(_suppliersSettingKey);
    if (jsonString == null) return SuppliersSetting.getDefault();
    return SuppliersSetting.fromJson(jsonDecode(jsonString));
  }

  static void setSuppliersSetting(SuppliersSetting obj) {
    _storage.setString(_suppliersSettingKey, jsonEncode(obj.toJson()));
  }

  static CustomersSetting getCustomersSetting() {
    final jsonString = _storage.getString(_customersSettingKey);
    if (jsonString == null) return CustomersSetting.getDefault();
    return CustomersSetting.fromJson(jsonDecode(jsonString));
  }

  static void setCustomersSetting(CustomersSetting obj) {
    _storage.setString(_customersSettingKey, jsonEncode(obj.toJson()));
  }

  static GoodsSetting getGoodsSetting() {
    final jsonString = _storage.getString(_goodsSettingKey);
    if (jsonString == null) return GoodsSetting.getDefault();
    return GoodsSetting.fromJson(jsonDecode(jsonString));
  }

  static void setGoodsSetting(GoodsSetting obj) {
    _storage.setString(_goodsSettingKey, jsonEncode(obj.toJson()));
  }

  static DocumentsSetting getDocumentsSetting() {
    final jsonString = _storage.getString(_documentsSettingKey);
    if (jsonString == null) return DocumentsSetting.getDefault();
    return DocumentsSetting.fromJson(jsonDecode(jsonString));
  }

  static void setDocumentsSetting(DocumentsSetting obj) {
    _storage.setString(_documentsSettingKey, jsonEncode(obj.toJson()));
  }

  static StoresSetting getStoresSetting() {
    final jsonString = _storage.getString(_storesSettingKey);
    if (jsonString == null) return StoresSetting.getDefault();
    return StoresSetting.fromJson(jsonDecode(jsonString));
  }

  static void setStoresSetting(StoresSetting obj) {
    _storage.setString(_storesSettingKey, jsonEncode(obj.toJson()));
  }

  static SaveDocumentSetting getSaveDocumentSetting() {
    final jsonString = _storage.getString(_saveDocumentSettingKey);
    if (jsonString == null) return SaveDocumentSetting.getDefault();
    return SaveDocumentSetting.fromJson(jsonDecode(jsonString));
  }

  static void setSaveDocumentSetting(SaveDocumentSetting obj) {
    _storage.setString(_saveDocumentSettingKey, jsonEncode(obj.toJson()));
  }

  static PaymentsSetting getPaymentsSetting() {
    final jsonString = _storage.getString(_PaymentsSettingKey);
    if (jsonString == null) return PaymentsSetting.getDefault();
    return PaymentsSetting.fromJson(jsonDecode(jsonString));
  }

  static void setPaymentsSetting(PaymentsSetting obj) {
    _storage.setString(_PaymentsSettingKey, jsonEncode(obj.toJson()));
  }

  static Color getIncomingDocumentColor() {
    return Color(
      _storage.getInt(
            _incomingDocumentColorKey,
          ) ??
          incomingDocumentColor.toARGB32(),
    );
  }

  static void setIncomingDocumentColor(Color color) {
    _storage.setInt(_incomingDocumentColorKey, color.toARGB32());
  }

  static Color getOutgoingDocumentColor() {
    return Color(
      _storage.getInt(
            _outgoingDocumentColorKey,
          ) ??
          outgoingDocumentColor.toARGB32(),
    );
  }

  static void setOutgoingDocumentColor(Color color) {
    _storage.setInt(_outgoingDocumentColorKey, color.toARGB32());
  }

  static int? getSavePaymentLastSelectedWalletId() {
    var result = _storage.getInt(_SavePaymentLastSelectedWalletIdKey) ?? -1;
    if (result == -1) {
      return null;
    }
    return result;
  }

  static void setSavePaymentLastSelectedWalletId(int? walletId) {
    if (walletId != null) {
      _storage.setInt(_SavePaymentLastSelectedWalletIdKey, walletId);
    }
  }

  static int getSelectedStoreId() {
    return _storage.getInt(_SelectedStoreIdKey) ?? -1;
  }

  static void setSelectedStoreId(int storeId) {
    _storage.setInt(_SelectedStoreIdKey, storeId);
  }

  static void increaseAutoDocumentNo(int storeId) {
    var key = _AutoDocumentNameKey + storeId.toString();
    int value = _storage.getInt(key) ?? -1;
    if (value == -1) {
      _storage.setInt(key, 1);
    } else {
      _storage.setInt(key, value + 1);
    }
  }

  static int getAutoDocumentNo(int storeId) {
    var key = _AutoDocumentNameKey + storeId.toString();
    int value = _storage.getInt(key) ?? -1;
    if (value == -1) {
      return 1;
    } else {
      return value + 1;
    }
  }

  static String getSelectedStoreName() {
    return _storage.getString(_SelectedStoreNameKey) ?? "";
  }

  static void setSelectedStoreName(String storeName) {
    _storage.setString(_SelectedStoreNameKey, storeName);
  }

  static void resetAutoDocumentNo() {
    var storeId = getSelectedStoreId();
    var key = _AutoDocumentNameKey + storeId.toString();
    _storage.setInt(key, 0);
  }

  static AppTheme get appTheme =>
      _box.get(_keyAppTheme, defaultValue: AppTheme.orange);

  static set appTheme(AppTheme value) => _box.put(_keyAppTheme, value);

  static AppLanguage get appLanguage =>
      _box.get(_keyAppLanguage, defaultValue: AppLanguage.english);

  static set appLanguage(AppLanguage value) => _box.put(_keyAppLanguage, value);

  static bool isPro() => _isPro;

  static Currency get currency =>
      _box.get(_keyCurrency, defaultValue: Currency.usd);

  static set currency(Currency value) => _box.put(_keyCurrency, value);
}
