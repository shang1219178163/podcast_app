import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/store_manager.dart';
import '../utils/dlog.dart';

class SettingsController extends GetxController {
  static const String _tag = 'SettingsController';
  // 播放设置
  final volume = 1.0.obs;
  final playbackSpeed = 1.0.obs;
  final autoStopMinutes = 0.obs;

  // 通知设置
  final pushNotification = true.obs;
  final downloadNotification = true.obs;
  final updateNotification = true.obs;

  // 其他设置
  final darkMode = false.obs;
  final autoPlay = false.obs;
  final cacheSize = '0MB'.obs;

  @override
  void onInit() {
    super.onInit();
    DLog.i('[$_tag] Initializing settings controller');
    loadSettings();
  }

  Future<void> loadSettings() async {
    DLog.d('[$_tag] Loading settings');
    // 加载播放设置
    volume.value = StoreManager.getDouble('volume') ?? 1.0;
    playbackSpeed.value = StoreManager.getDouble('playbackSpeed') ?? 1.0;
    autoStopMinutes.value = StoreManager.getInt('autoStopMinutes') ?? 0;

    // 加载通知设置
    pushNotification.value = StoreManager.getBool('pushNotification') ?? true;
    downloadNotification.value = StoreManager.getBool('downloadNotification') ?? true;
    updateNotification.value = StoreManager.getBool('updateNotification') ?? true;

    // 加载其他设置
    darkMode.value = StoreManager.getBool('darkMode') ?? false;
    autoPlay.value = StoreManager.getBool('autoPlay') ?? false;

    // 计算缓存大小
    await calculateCacheSize();
    DLog.d('[$_tag] Settings loaded successfully');
  }

  Future<void> saveSettings() async {
    DLog.d('[$_tag] Saving settings');
    try {
      // 保存播放设置
      await StoreManager.setDouble('volume', volume.value);
      await StoreManager.setDouble('playbackSpeed', playbackSpeed.value);
      await StoreManager.setInt('autoStopMinutes', autoStopMinutes.value);

      // 保存通知设置
      await StoreManager.setBool('pushNotification', pushNotification.value);
      await StoreManager.setBool('downloadNotification', downloadNotification.value);
      await StoreManager.setBool('updateNotification', updateNotification.value);

      // 保存其他设置
      await StoreManager.setBool('darkMode', darkMode.value);
      await StoreManager.setBool('autoPlay', autoPlay.value);
      DLog.i('[$_tag] Settings saved successfully');
    } catch (e) {
      DLog.e('[$_tag] Error saving settings: $e');
    }
  }

  Future<void> calculateCacheSize() async {
    DLog.d('[$_tag] Calculating cache size');
    // TODO: 实现缓存大小计算
    cacheSize.value = '0MB';
  }

  Future<void> clearCache() async {
    DLog.d('[$_tag] Clearing cache');
    try {
      // TODO: 实现缓存清理
      await calculateCacheSize();
      Get.snackbar(
        '提示',
        '缓存已清理',
        snackPosition: SnackPosition.BOTTOM,
      );
      DLog.i('[$_tag] Cache cleared successfully');
    } catch (e) {
      DLog.e('[$_tag] Error clearing cache: $e');
    }
  }

  Future<void> logout() async {
    DLog.d('[$_tag] Showing logout confirmation dialog');
    await Get.dialog(
      AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () {
              DLog.d('[$_tag] Logout cancelled');
              Get.back();
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              DLog.i('[$_tag] User confirmed logout');
              Get.back();
              // TODO: 执行退出登录操作
              Get.offAllNamed('/login');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
