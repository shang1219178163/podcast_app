import 'package:get/get.dart';
import '../routes/app_pages.dart';

class DiscoverController extends GetxController {
  // 路由列表数据
  final routes = <String>[].obs;
  final filteredRoutes = <String>[].obs;
  final searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // 初始化时立即加载数据
    initRoutes();
  }

  void initRoutes() {
    // 过滤掉登录和底部导航相关路由
    final allRoutes =
        AppRoute.values.where((route) => !route.startsWith('/login') && !route.startsWith('/tabBar')).toList();

    routes.value = allRoutes;
    filteredRoutes.value = allRoutes;
  }

  // 刷新数据
  Future<void> refreshData() async {
    initRoutes();
    filterRoutes(searchText.value);
  }

  // 过滤路由
  void filterRoutes(String query) {
    searchText.value = query;
    if (query.isEmpty) {
      filteredRoutes.value = routes;
      return;
    }

    filteredRoutes.value = routes.where((route) {
      final title =
          route.substring(1).replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim().toLowerCase();
      return title.contains(query.toLowerCase()) || route.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // 处理路由点击
  void onRouteSelected(String route) {
    Get.toNamed(route);
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  // 加载数据
  Future<void> loadData() async {
    try {
      routes.value =
          AppRoute.values.where((route) => !route.startsWith('/login') && !route.startsWith('/tabBar')).toList();
    } catch (e) {
      // 这里可以添加错误处理逻辑
    }
  }


  // 获取所有路由名称
  List<String> getAllRoutes() {
    return [
      'login',
      'tabBar',
      'home',
      'discover',
      'subscription',
      'profile',
      'userAgreement',
      'privacyPolicy',
      'player',
      'podcastDetail',
      'settings',
      'categoryDetail',
      'notificationSettings',
      'volumeSettings',
      'timerSettings',
      'playbackSpeedSettings',
      'personalProfile',
      'accountSecurity',
      'favorites',
      'history',
      'downloads',
      'messages',
      'register',
      'audioPlayer',
    ];
  }

  // 跳转到指定路由
  void navigateToRoute(String route) {
    final fullRoute = '/${route.replaceAll(RegExp(r'(?=[A-Z])'), '-').toLowerCase()}';
    Get.toNamed(fullRoute);
  }
}
