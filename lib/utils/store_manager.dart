import 'package:podcast_app/utils/dlog.dart';

import '../constants/store_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreManager {
  static final StoreManager _instance = StoreManager._internal();
  static SharedPreferences? _prefs;

  factory StoreManager() {
    return _instance;
  }

  StoreManager._internal();

  static Future<void> init() async {
    DLog.i('Initializing StoreManager');
    _prefs = await SharedPreferences.getInstance();
  }

  // 获取所有键
  static Set<String> getKeys() {
    return _prefs?.getKeys() ?? {};
  }

  // 获取所有数据
  static Map<String, dynamic> getAll() {
    return Map.fromEntries(_prefs?.getKeys().map((key) => MapEntry(key, _prefs?.get(key))) ?? []);
  }

  // 检查键是否存在
  static bool containsKey(String key) {
    final exists = _prefs?.containsKey(key) ?? false;
    DLog.d('Checking if $key exists: $exists');
    return exists;
  }

  // 获取字符串
  static String? getString(String key) {
    final value = _prefs?.getString(key);
    DLog.d('Getting string for $key: $value');
    return value;
  }

  // 设置字符串
  static Future<bool> setString(String key, String value) async {
    DLog.d('Setting string for $key: $value');
    return await _prefs?.setString(key, value) ?? false;
  }

  // 获取布尔值
  static bool? getBool(String key) {
    final value = _prefs?.getBool(key);
    DLog.d('Getting bool for $key: $value');
    return value;
  }

  // 设置布尔值
  static Future<bool> setBool(String key, bool value) async {
    DLog.d('Setting bool for $key: $value');
    return await _prefs?.setBool(key, value) ?? false;
  }

  // 获取整数
  static int? getInt(String key) {
    final value = _prefs?.getInt(key);
    DLog.d('Getting int for $key: $value');
    return value;
  }

  // 设置整数
  static Future<bool> setInt(String key, int value) async {
    DLog.d('Setting int for $key: $value');
    return await _prefs?.setInt(key, value) ?? false;
  }

  // 获取双精度浮点数
  static double? getDouble(String key) {
    final value = _prefs?.getDouble(key);
    DLog.d('Getting double for $key: $value');
    return value;
  }

  // 设置双精度浮点数
  static Future<bool> setDouble(String key, double value) async {
    DLog.d('Setting double for $key: $value');
    return await _prefs?.setDouble(key, value) ?? false;
  }

  // 获取字符串列表
  static List<String>? getStringList(String key) {
    final value = _prefs?.getStringList(key);
    DLog.d('Getting string list for $key: $value');
    return value;
  }

  // 设置字符串列表
  static Future<bool> setStringList(String key, List<String> value) async {
    DLog.d('Setting string list for $key: $value');
    return await _prefs?.setStringList(key, value) ?? false;
  }

  // 获取对象（JSON）
  static dynamic getObject(String key) {
    final String? jsonString = _prefs?.getString(key);
    DLog.d('Getting object for $key: $jsonString');
    if (jsonString == null) return null;
    return jsonString;
  }

  // 设置对象（JSON）
  static Future<bool> setObject(String key, dynamic value) async {
    DLog.d('Setting object for $key: $value');
    if (value == null) {
      return await remove(key);
    }
    return await _prefs?.setString(key, value.toString()) ?? false;
  }

  // 删除指定键
  static Future<bool> remove(String key) async {
    DLog.d('Removing $key');
    return await _prefs?.remove(key) ?? false;
  }

  // 清空所有数据
  static Future<bool> clear() async {
    DLog.w('Clearing all data');
    return await _prefs?.clear() ?? false;
  }

  // 清除所有需要登录的数据
  static Future<void> clearLoginRequiredData() async {
    DLog.w('Clearing all login-required data');
    for (var key in StoreKey.values) {
      if (key.logined) {
        await remove(key.name);
      }
    }
  }

  // 重新加载数据
  static Future<void> reload() async {
    await _prefs?.reload();
  }

  // 获取所有键值对
  static Map<String, dynamic> getValues() {
    return getAll();
  }

  // 获取指定键的值类型
  static Type? getValueType(String key) {
    if (_prefs == null) return null;
    if (!_prefs!.containsKey(key)) return null;
    return _prefs!.get(key).runtimeType;
  }

  // 检查是否为空
  static bool isEmpty() {
    return _prefs?.getKeys().isEmpty ?? true;
  }

  // 获取数据大小
  static int getSize() {
    return _prefs?.getKeys().length ?? 0;
  }

  // 获取所有键的列表
  static List<String> getKeysList() {
    return _prefs?.getKeys().toList() ?? [];
  }

  // 获取所有值的列表
  static List<dynamic> getValuesList() {
    return getAll().values.toList();
  }

  // 获取所有键值对的列表
  static List<MapEntry<String, dynamic>> getEntries() {
    return getAll().entries.toList();
  }

  // 获取指定键的值（通用方法）
  static dynamic getValue(String key) {
    return _prefs?.get(key);
  }

  // 设置指定键的值（通用方法）
  static Future<bool> setValue(String key, dynamic value) async {
    if (value == null) {
      return await remove(key);
    }
    if (value is String) {
      return await setString(key, value);
    }
    if (value is bool) {
      return await setBool(key, value);
    }
    if (value is int) {
      return await setInt(key, value);
    }
    if (value is double) {
      return await setDouble(key, value);
    }
    if (value is List<String>) {
      return await setStringList(key, value);
    }
    return await setString(key, value.toString());
  }
}
