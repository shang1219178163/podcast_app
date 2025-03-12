// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tab_bar_controller.dart';
import '../pages/home_page.dart';
import '../pages/subscription_page.dart';
import '../pages/discover_page.dart';
import '../pages/profile_page.dart';
import '../widgets/app_drawer.dart';

class TabBarPage extends GetView<NTabBarController> {
  const TabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      drawer: AppDrawer(),
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomePage(),
            DiscoverPage(),
            SubscriptionPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeNav,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.primary,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          items: controller.items,
        ),
      ),
    );
  }
}
