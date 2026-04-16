abstract class Storage {
  Future<bool> setInt(key, value);

  int? getInt(key);

  Future<bool> setBool(key, value);

  bool? getBool(key);

  Future<bool> setString(key, value);

  String? getString(key);
}
