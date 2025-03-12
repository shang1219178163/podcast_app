import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/tab_bar_controller.dart';
import '../constants/app_constants.dart';
import '../theme/theme_provider.dart';
import '../widgets/network_image_widget.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // 主题颜色选项
  final List<Color> _themeColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  final tabController = Get.find<NTabBarController>();

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

          // 默认导航项设置
          GetBuilder<NTabBarController>(
            builder: (controller) => ListTile(
              leading: Icon(Icons.menu, color: theme.colorScheme.primary),
              title: Text(
                '默认导航项',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                tabController.barItem.label ?? "",
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
              ),
              onTap: () => _showNavigationSettings(context),
            ),
          ),

          // 分割线
          Divider(color: theme.dividerColor),

          // 其他设置项...
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
              builder: (controller) => DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    // 添加 TabBar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TabBar(
                        tabs: const [
                          Tab(text: '主题模式'),
                          Tab(text: '颜色选择'),
                        ],
                        labelColor: theme.colorScheme.primary,
                        unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: theme.colorScheme.primary.withOpacity(0.1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: TabBarView(
                        children: [
                          // 主题模式选项
                          ListView(
                            shrinkWrap: true,
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
                                  },
                                ),
                              ),
                            ],
                          ),
                          // 颜色选择选项
                          GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1,
                            ),
                            itemCount: _themeColors.length,
                            itemBuilder: (context, index) {
                              final color = _themeColors[index];
                              final isSelected = controller.primaryColor == color;
                              return GestureDetector(
                                onTap: () {
                                  controller.setPrimaryColor(color);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? theme.colorScheme.onSurface : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          color: theme.colorScheme.onSurface,
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNavigationSettings(BuildContext context) {
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
              '默认导航项设置',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            GetBuilder<NTabBarController>(
              builder: (controller) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tabController.items.length,
                  itemBuilder: (context, index) {
                    final item = tabController.items[index];
                    return ListTile(
                      leading: item.icon,
                      title: Text(
                        item.label ?? "",
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      trailing: Radio<int>(
                        value: index,
                        groupValue: controller.selectedIndex.value,
                        onChanged: (value) {},
                      ),
                      onTap: () {
                        controller.changeNav(index);
                        Get.back();
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 导航项数据类
class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}
