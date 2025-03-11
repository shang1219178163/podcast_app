import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:podcast_app/utils/store_manager.dart';
import 'app_theme.dart';

class ThemeProvider extends GetxController {
  static ThemeProvider get to => Get.find();

  // 主题模式
  static const String _themeKey = 'theme_mode';

  // 主题模式状态
  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  // 主题变化回调
  VoidCallback? onThemeChanged;

  // 是否是暗黑模式
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  @override
  void onInit() {
    super.onInit();
    // 读取持久化的主题设置
    _loadThemeMode();
    // 监听系统主题变化
    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (_themeMode.value == ThemeMode.system) {
        _applyTheme();
      }
    };

    // 监听主题模式变化
    ever(_themeMode, (_) {
      _applyTheme();
    });
  }

  // 加载主题设置
  void _loadThemeMode() {
    final String? savedMode = StoreManager.getString(_themeKey);
    if (savedMode != null) {
      switch (savedMode) {
        case 'system':
          _themeMode.value = ThemeMode.system;
          break;
        case 'light':
          _themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          _themeMode.value = ThemeMode.dark;
          break;
      }
    }
    // 应用主题
    _applyTheme();
  }

  // 保存主题设置
  Future<void> _saveThemeMode(ThemeMode mode) async {
    await StoreManager.setString(_themeKey, mode.name);
  }

  // 应用主题
  void _applyTheme() {
    Get.changeThemeMode(_themeMode.value);
    Get.changeTheme(isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme);
    onThemeChanged?.call();
    update();
  }

  // 切换主题模式
  Future<void> toggleTheme() async {
    if (_themeMode.value == ThemeMode.system) {
      _themeMode.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    } else if (_themeMode.value == ThemeMode.light) {
      _themeMode.value = ThemeMode.dark;
    } else {
      _themeMode.value = ThemeMode.light;
    }
    await _saveThemeMode(_themeMode.value);
  }

  // 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode.value != mode) {
      _themeMode.value = mode;
      await _saveThemeMode(mode);
    }
  }

  // 重置为系统主题
  Future<void> resetToSystem() async {
    await setThemeMode(ThemeMode.system);
  }
}
