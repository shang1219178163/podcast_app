import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:podcast_app/utils/store_manager.dart';
import 'app_theme.dart';

class ThemeProvider extends GetxController {
  static ThemeProvider get to => Get.find();

  // 存储键
  static const String _themeKey = 'theme_mode';
  static const String _colorKey = 'theme_color';

  // 主题模式状态
  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  // 主题颜色状态
  final Rx<Color> _primaryColor = const Color(0xFF07C160).obs;
  Color get primaryColor => _primaryColor.value;

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
    _loadPrimaryColor();
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

    // 监听主题颜色变化
    ever(_primaryColor, (_) {
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
  }

  // 加载主题颜色
  void _loadPrimaryColor() {
    final int? savedColor = StoreManager.getInt(_colorKey);
    if (savedColor != null) {
      _primaryColor.value = Color(savedColor);
    }
  }

  // 保存主题设置
  Future<void> _saveThemeMode(ThemeMode mode) async {
    await StoreManager.setString(_themeKey, mode.name);
  }

  // 保存主题颜色
  Future<void> _savePrimaryColor(Color color) async {
    await StoreManager.setInt(_colorKey, color.value);
  }

  // 应用主题
  void _applyTheme() {
    // 创建自定义主题
    final lightTheme = AppTheme.lightTheme.copyWith(
      colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
        primary: _primaryColor.value,
        secondary: _primaryColor.value,
      ),
    );

    final darkTheme = AppTheme.darkTheme.copyWith(
      colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
        primary: _primaryColor.value,
        secondary: _primaryColor.value,
      ),
    );

    Get.changeThemeMode(_themeMode.value);
    Get.changeTheme(isDarkMode ? darkTheme : lightTheme);
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

  // 设置主题颜色
  Future<void> setPrimaryColor(Color color) async {
    if (_primaryColor.value != color) {
      _primaryColor.value = color;
      await _savePrimaryColor(color);
    }
  }

  // 重置为系统主题
  Future<void> resetToSystem() async {
    await setThemeMode(ThemeMode.system);
  }

  // 重置为默认颜色
  Future<void> resetToDefaultColor() async {
    await setPrimaryColor(const Color(0xFF07C160));
  }
}
