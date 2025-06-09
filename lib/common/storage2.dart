abstract class Storage2 {
  void write(String key, String value);
  String? read(String key);
  void remove(String key);
}