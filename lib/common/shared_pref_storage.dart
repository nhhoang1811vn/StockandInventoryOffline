import 'package:good_manager/common/storage2.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';


@LazySingleton(as: Storage2)
class SharedPrefStorage implements Storage2 {
  final SharedPreferences prefs;

  SharedPrefStorage(this.prefs);

  @override
  Future<void> write(String key, String value) async {
    await prefs.setString(key, value);
  }

  @override
  Future<String?> read(String key) async {
    return prefs.getString(key);
  }

  @override
  Future<void> remove(String key) async {
    await prefs.remove(key);
  }
}
