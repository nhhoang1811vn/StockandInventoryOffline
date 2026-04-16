import 'package:shared_preferences/shared_preferences.dart';

import 'storage.dart';

class PrefStorage extends Storage {
  late SharedPreferences _prefs;

  PrefStorage({required SharedPreferences prefs}) {
    _prefs = prefs;
  }

  static Future<Storage> init() async {
    var prefs = await SharedPreferences.getInstance();
    return PrefStorage(prefs: prefs);
  }

  @override
  Future<bool> setInt(key, value) {
    return _prefs.setInt(key, value);
  }

  @override
  int? getInt(key) {
    return _prefs.getInt(key);
  }

  @override
  Future<bool> setBool(key, value) {
    return _prefs.setBool(key, value);
  }

  @override
  bool? getBool(key) {
    return _prefs.getBool(key);
  }

  @override
  Future<bool> setString(key, value) {
    return _prefs.setString(key, value);
  }

  @override
  String? getString(key) {
    return _prefs.getString(key);
  }
}
