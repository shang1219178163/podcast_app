import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../theme/theme_provider.dart';
import '../widgets/network_image_widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // 用户头像区域
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
            ),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.surface,
              child: ClipOval(
                child: NetworkImageWidget(
                  url: AppConstants.podcastCovers['future_tech'] ?? AppConstants.placeholderImage,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    width: 80,
                    height: 80,
                    color: theme.colorScheme.surface,
                    child: Icon(Icons.person, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                  ),
                ),
              ),
            ),
            accountName: Text(
              '用户名',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            accountEmail: Text(
              'ID: 888888',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),

          // 主题设置
          ListTile(
            leading: Icon(Icons.palette_outlined, color: theme.colorScheme.primary),
            title: Text(
              '主题设置',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            subtitle: Text(
              _getThemeModeText(),
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
            onTap: () => _showThemeSettings(context),
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
                    title: Text(
                      '跟随系统',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
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
                    title: Text(
                      '浅色模式',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
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
                    title: Text(
                      '深色模式',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
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
}
