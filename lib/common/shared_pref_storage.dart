import 'package:good_manager/common/storage2.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';


@LazySingleton(as: Storage2)
class SharedPrefStorage implements Storage2 {
  final SharedPreferences prefs;

  SharedPrefStorage(this.prefs);

  @override
  void write(String key, String value){
    prefs.setString(key, value);
  }

  @override
  String? read(String key){
    return prefs.getString(key);
  }

  @override
  void remove(String key){
    prefs.remove(key);
  }
}
