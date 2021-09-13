import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;

  static SharedPreferences get instance => _preferences;

  static Future<StorageUtil> getInstance() async {
    if (_storageUtil == null) {
      StorageUtil singlePreferences = StorageUtil._();
      await singlePreferences._init();
      _storageUtil = singlePreferences;
    }
    return _storageUtil;
  }

  StorageUtil._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String getString(String key, {String defaultValue = ""}) {
    if (_preferences == null) return defaultValue;
    return _preferences.getString(key) ?? defaultValue;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    if (_preferences == null) return defaultValue;
    return _preferences.getBool(key) ?? defaultValue;
  }

  static int getInt(String key, {int defaultValue = 0}) {
    if (_preferences == null) return defaultValue;
    return _preferences.getInt(key) ?? defaultValue;
  }

  static double getDouble(String key, {double defaultValue = 0.00}) {
    if (_preferences == null) return defaultValue;
    return _preferences.getDouble(key) ?? defaultValue;
  }

  static List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    if (_preferences == null) return defaultValue;
    return _preferences.getStringList(key) ?? defaultValue;
  }

  static Set<String> getKeys(String key, {Set<String> defaultValue = const {}}) {
    if (_preferences == null) return defaultValue;
    return _preferences.getKeys() ?? defaultValue;
  }
}
