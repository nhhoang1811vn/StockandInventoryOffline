abstract class Storage2 {
  void write(String key, String value);
  void writeInt(String key, int value);
  String? read(String key);
  int readInt(String key, int defaultValue);
  void remove(String key);
}