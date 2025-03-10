import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/constants/store_key.dart';
import 'package:podcast_app/utils/store_manager.dart';
import 'routes/app_pages.dart';
import 'bindings/initial_binding.dart';
import 'package:podcast_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StoreManager.init();


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
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
    );
  }
}
