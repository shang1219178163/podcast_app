// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tab_bar_controller.dart';

import 'home_page.dart';
import 'discover_page.dart';
import 'subscription_page.dart';
import 'profile_page.dart';

class TabBarPage extends GetView<NTabBarController> {
  const TabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              HomePage(),
              DiscoverPage(),
              SubscriptionPage(),
              ProfilePage(),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changePage,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '首页',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: '发现',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: '订阅',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '我的',
              ),
            ],
          )),
    );
  }
}
