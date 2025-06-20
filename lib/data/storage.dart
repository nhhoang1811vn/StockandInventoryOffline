import 'package:good_manager/domain/entities/batch_mode_scan.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class Storage {
  late SharedPreferences prefs;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(StorageKeys.InitSettings)) {
      prefs.setInt(StorageKeys.BarcodeScannerBatchScanMode, BatchModeScan.MANUAL.value);
      prefs.setBool(StorageKeys.BarcodeScannerEnableBeep, true);
      prefs.setBool(StorageKeys.BarcodeScannerEnableVibrate, true);
      prefs.setBool(StorageKeys.InitSettings, true);
    }
  }

  int getSelectedStoreId() {
    return prefs.getInt(StorageKeys.SelectedStoreId) ?? -1;
  }

  void setSelectedStoreId(int storeId) {
    prefs.setInt(StorageKeys.SelectedStoreId, storeId);
  }

  String getSelectedStoreName() {
    return prefs.getString(StorageKeys.SelectedStoreName) ?? "";
  }

  void setSelectedStoreName(String value) {
    prefs.setString(StorageKeys.SelectedStoreName, value);
  }

  bool getFirstTime() {
    return prefs.getBool(StorageKeys.FirstTime) ?? true;
  }

  void setFirstTime(bool value) {
    prefs.setBool(StorageKeys.FirstTime, value);
  }

  void setLanguageCode(String value) {
    prefs.setString(StorageKeys.LanguageCode, value);
  }

  String getLanguageCode() {
    return prefs.getString(StorageKeys.LanguageCode) ?? "en";
  }
  int getAutoDocumentNo(int storeId) {
    int? value =
        prefs.getInt(StorageKeys.AutoDocumentName + storeId.toString());
    if (value == null) {
      return 1;
    } else {
      return value + 1;
    }
  }
  void resetAutoDocumentNo(int storeId, ){
    prefs.setInt(StorageKeys.AutoDocumentName + storeId.toString(), 0);
  }

  void increaseAutoDocumentNo(int storeId) {
    int? value =
        prefs.getInt(StorageKeys.AutoDocumentName + storeId.toString());
    if (value == null) {
      prefs.setInt(StorageKeys.AutoDocumentName + storeId.toString(), 1);
    } else {
      prefs.setInt(
          StorageKeys.AutoDocumentName + storeId.toString(), value + 1);
    }
  }

  void setBarcodeScannerEnableBeep(bool value) {
    prefs.setBool(StorageKeys.BarcodeScannerEnableBeep, value);
  }

  bool getBarcodeScannerEnableBeep() {
    return prefs.getBool(StorageKeys.BarcodeScannerEnableBeep)!;
  }

  void setBarcodeScannerEnableVibrate(bool value) {
    prefs.setBool(StorageKeys.BarcodeScannerEnableVibrate, value);
  }

  bool getBarcodeScannerEnableVibrate() {
    return prefs.getBool(StorageKeys.BarcodeScannerEnableVibrate)!;
  }

  BatchModeScan getBatchModeScan() {
    int value = prefs.getInt(StorageKeys.BarcodeScannerBatchScanMode)!;
    if (value == BatchModeScan.MANUAL.value) {
      return BatchModeScan.MANUAL;
    } else {
      return BatchModeScan.AUTO;
    }
  }

  void setBatchModeScan(BatchModeScan mode) {
    prefs.setInt(StorageKeys.BarcodeScannerBatchScanMode, mode.value);
  }

  void setEnablePasscode(bool value) {
    prefs.setBool(StorageKeys.EnablePasscodeKey, value);
  }

  bool getEnablePasscode() {
    return prefs.getBool(StorageKeys.EnablePasscodeKey) ?? false;
  }
  void setPasscode(String passcode) {
    prefs.setString(StorageKeys.UserPasscodeKey, passcode);
  }

  String getPasscode() {
    return prefs.getString(StorageKeys.UserPasscodeKey) ?? "";
  }
}

class StorageKeys {
  static const String InitSettings = "InitSettings2";
  static const String BarcodeScannerBatchScanMode =
      "BarcodeScannerBatchScanMode";
  static const String BarcodeScannerEnableBeep = "BarcodeScannerEnableBeep";
  static const String BarcodeScannerEnableVibrate =
      "BarcodeScannerEnableVibrate";

  static const String SelectedStoreId = "SelectedStoreId";
  static const String SelectedStoreName = "SelectedStoreName";
  static const String FirstTime = "FirstTime";
  static const String LanguageCode = "LanguageCode";

  static const String AutoDocumentName = "AutoDocumentName";
  static const String EnablePasscodeKey = "EnablePasscode";
  static const String UserPasscodeKey = "UserPasscode";
}
