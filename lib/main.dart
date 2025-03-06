import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/utils/store_manager.dart';
import 'routes/app_pages.dart';
import 'bindings/initial_binding.dart';
import 'package:podcast_app/theme/app_theme.dart';
import 'package:podcast_app/controllers/audio_player_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StoreManager.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '播客应用',
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      debugShowCheckedModeBanner: false,
    );
  }
}
