import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../theme/theme_provider.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '设置',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: '账号设置',
            children: [
              _buildListTile(
                icon: Icons.person_outline,
                title: '个人资料',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.notifications_outlined,
                title: '消息通知',
                onTap: () => _showNotificationSettings(context),
              ),
              _buildListTile(
                icon: Icons.security_outlined,
                title: '账号安全',
                onTap: () {},
              ),
            ],
          ),
          _buildSection(
            title: '播放设置',
            children: [
              _buildListTile(
                icon: Icons.volume_up,
                title: '播放音量',
                onTap: () => _showVolumeSettings(context),
              ),
              _buildListTile(
                icon: Icons.timer,
                title: '定时关闭',
                onTap: () => _showTimerSettings(context),
              ),
              _buildListTile(
                icon: Icons.speed,
                title: '播放速度',
                onTap: () => _showSpeedSettings(context),
              ),
              Obx(() => SwitchListTile(
                    secondary: Icon(
                      Icons.play_circle_outline,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text('自动播放'),
                    value: controller.autoPlay.value,
                    onChanged: (value) {
                      controller.autoPlay.value = value;
                      controller.saveSettings();
                    },
                  )),
            ],
          ),
          _buildSection(
            title: '外观',
            children: [
              _buildListTile(
                icon: Icons.palette_outlined,
                title: '主题设置',
                subtitle: _getThemeModeText(),
                onTap: () => _showThemeSettings(context),
              ),
            ],
          ),
          _buildSection(
            title: '其他',
            children: [
              _buildListTile(
                icon: Icons.cleaning_services_outlined,
                title: '清除缓存',
                subtitle: controller.cacheSize.value,
                onTap: () => controller.clearCache(),
              ),
              _buildListTile(
                icon: Icons.info_outline,
                title: '关于我们',
                onTap: () => _showAboutDialog(context),
              ),
              _buildListTile(
                icon: Icons.logout,
                title: '退出登录',
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getThemeModeText() {
    switch (ThemeProvider.to.themeMode) {
      case ThemeMode.system:
        return '跟随系统';
      case ThemeMode.light:
        return '浅色模式';
      case ThemeMode.dark:
        return '深色模式';
    }
  }

  void _showThemeSettings(BuildContext context) {
    final theme = Theme.of(context);
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '主题设置',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            GetBuilder<ThemeProvider>(
              builder: (controller) => Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.brightness_auto,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text('跟随系统'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: controller.themeMode,
                      onChanged: (value) {
                        controller.setThemeMode(value!);
                        Get.back();
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.light_mode,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text('浅色模式'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: controller.themeMode,
                      onChanged: (value) {
                        controller.setThemeMode(value!);
                        Get.back();
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.dark_mode,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text('深色模式'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: controller.themeMode,
                      onChanged: (value) {
                        controller.setThemeMode(value!);
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(Get.context!).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(Get.context!);
    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: onTap,
    );
  }

  void _showNotificationSettings(BuildContext context) {
    final theme = Theme.of(context);
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '通知设置',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
                  children: [
                    SwitchListTile(
                      title: Text('推送通知', style: TextStyle(color: theme.colorScheme.onSurface)),
                      value: controller.pushNotification.value,
                      onChanged: (value) {
                        controller.pushNotification.value = value;
                        controller.saveSettings();
                      },
                    ),
                    SwitchListTile(
                      title: Text('下载通知', style: TextStyle(color: theme.colorScheme.onSurface)),
                      value: controller.downloadNotification.value,
                      onChanged: (value) {
                        controller.downloadNotification.value = value;
                        controller.saveSettings();
                      },
                    ),
                    SwitchListTile(
                      title: Text('更新通知', style: TextStyle(color: theme.colorScheme.onSurface)),
                      value: controller.updateNotification.value,
                      onChanged: (value) {
                        controller.updateNotification.value = value;
                        controller.saveSettings();
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _showVolumeSettings(BuildContext context) {
    final theme = Theme.of(context);
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '音量设置',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
                  children: [
                    Slider(
                      value: controller.volume.value,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: '${(controller.volume.value * 100).round()}%',
                      onChanged: (value) {
                        controller.volume.value = value;
                        controller.saveSettings();
                      },
                    ),
                    Text('${(controller.volume.value * 100).round()}%'),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _showTimerSettings(BuildContext context) {
    final theme = Theme.of(context);
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '定时关闭',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
                  children: [
                    ListTile(
                      title: const Text('关闭'),
                      trailing: Radio<int>(
                        value: 0,
                        groupValue: controller.autoStopMinutes.value,
                        onChanged: (value) {
                          controller.autoStopMinutes.value = value!;
                          controller.saveSettings();
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('15分钟'),
                      trailing: Radio<int>(
                        value: 15,
                        groupValue: controller.autoStopMinutes.value,
                        onChanged: (value) {
                          controller.autoStopMinutes.value = value!;
                          controller.saveSettings();
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('30分钟'),
                      trailing: Radio<int>(
                        value: 30,
                        groupValue: controller.autoStopMinutes.value,
                        onChanged: (value) {
                          controller.autoStopMinutes.value = value!;
                          controller.saveSettings();
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('60分钟'),
                      trailing: Radio<int>(
                        value: 60,
                        groupValue: controller.autoStopMinutes.value,
                        onChanged: (value) {
                          controller.autoStopMinutes.value = value!;
                          controller.saveSettings();
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _showSpeedSettings(BuildContext context) {
    final theme = Theme.of(context);
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '播放速度',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
                  children: [
                    ListTile(
                      title: const Text('0.5x'),
                      trailing: Radio<double>(
                        value: 0.5,
                        groupValue: controller.playbackSpeed.value,
                        onChanged: (value) {
                          controller.playbackSpeed.value = value!;
                          controller.saveSettings();
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('1.0x'),
                      trailing: Radio<double>(
                        value: 1.0,
                        groupValue: controller.playbackSpeed.value,
                        onChanged: (value) {
                          controller.playbackSpeed.value = value!;
                          controller.saveSettings();
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('1.5x'),
                      trailing: Radio<double>(
                        value: 1.5,
                        groupValue: controller.playbackSpeed.value,
                        onChanged: (value) {
                          controller.playbackSpeed.value = value!;
                          controller.saveSettings();
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('2.0x'),
                      trailing: Radio<double>(
                        value: 2.0,
                        groupValue: controller.playbackSpeed.value,
                        onChanged: (value) {
                          controller.playbackSpeed.value = value!;
                          controller.saveSettings();
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('关于我们'),
        content: const Text('播客 v1.0.0\n\n聆听世界的声音'),
        actions: [
          CupertinoDialogAction(
            child: const Text('确定'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('确定'),
            onPressed: () {
              Navigator.pop(context);
              controller.logout();
            },
          ),
        ],
      ),
    );
  }
}
