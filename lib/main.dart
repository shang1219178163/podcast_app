import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/theme/theme_provider.dart';
import 'package:podcast_app/utils/store_manager.dart';
import 'constants/store_key.dart';
import 'routes/app_pages.dart';
import 'bindings/initial_binding.dart';
import 'package:podcast_app/theme/app_theme.dart';
import 'controllers/settings_controller.dart';
import 'controllers/player_controller.dart';
import 'controllers/tab_bar_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化存储
  await StoreManager.init();

  // 初始化控制器
  Get.put(ThemeProvider());
  Get.put(SettingsController());
  Get.put(PlayerController());
  Get.put(NTabBarController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 根据登录状态决定初始路由
    final bool isLoggedIn = StoreManager.getBool(StoreKey.isLoggedIn.name) ?? false;
    final String initialRoute = isLoggedIn ? AppRoute.tabBar : AppRoute.login;
    // LogUtil.i('Initial route: $initialRoute (isLoggedIn: $isLoggedIn)');

    return GetMaterialApp(
      title: '播客应用',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
        useMaterial3: true,
        // 关闭水波纹效果
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        // 自定义按钮主题
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        // 自定义 ListTile 主题
        listTileTheme: const ListTileThemeData(
          enableFeedback: false,
        ),
        // 自定义 InkWell 主题
        cardTheme: const CardTheme(
          clipBehavior: Clip.none,
        ),
      ),
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeProvider.to.themeMode,
      initialBinding: InitialBinding(),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
    );
  }
}
