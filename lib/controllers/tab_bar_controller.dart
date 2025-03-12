import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/utils/dlog.dart';
import 'package:podcast_app/utils/store_manager.dart';

class NTabBarController extends GetxController {
  static NTabBarController get to => Get.find();

  // 存储键
  static const String _navIndexKey = 'bottom_nav_index';

  // 当前选中的索引
  final RxInt selectedIndex = 0.obs;

  // 导航项列表
  final List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: '首页',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.explore_outlined),
      activeIcon: Icon(Icons.explore),
      label: '发现',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.subscriptions_outlined),
      activeIcon: Icon(Icons.subscriptions),
      label: '订阅',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: '我的',
    ),
  ];

  // 当前选中的导航项
  BottomNavigationBarItem get barItem => selectedIndex.value < items.length ? items[selectedIndex.value] : items.first;

  // 导航变化回调
  Function(int)? onNavigationChanged;

  @override
  void onInit() {
    super.onInit();
    // 读取持久化的导航索引
    _loadNavIndex();
  }

  // 加载导航索引
  void _loadNavIndex() {
    final int? savedIndex = StoreManager.getInt(_navIndexKey);
    if (savedIndex != null) {
      selectedIndex.value = savedIndex;
    }
  }

  // 保存导航索引
  Future<void> _saveNavIndex(int index) async {
    await StoreManager.setInt(_navIndexKey, index);
  }

  // 切换导航索引
  Future<void> changeNav(int index) async {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      await _saveNavIndex(index);
      onNavigationChanged?.call(index);
      update();
    }
  }
}
