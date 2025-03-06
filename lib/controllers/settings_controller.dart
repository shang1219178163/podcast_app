import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/store_manager.dart';

class SettingsController extends GetxController {
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
    loadSettings();
  }

  Future<void> loadSettings() async {
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
  }

  Future<void> saveSettings() async {
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
  }

  Future<void> calculateCacheSize() async {
    // TODO: 实现缓存大小计算
    cacheSize.value = '0MB';
  }

  Future<void> clearCache() async {
    // TODO: 实现缓存清理
    await calculateCacheSize();
    Get.snackbar(
      '提示',
      '缓存已清理',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> logout() async {
    // TODO: 实现退出登录
    Get.dialog(
      AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
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
