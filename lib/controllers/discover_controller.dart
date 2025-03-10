import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../models/podcast.dart';
import '../utils/log_util.dart';

class DiscoverController extends GetxController {
  // 路由列表数据
  final routes = <String>[].obs;
  final filteredRoutes = <String>[].obs;
  final searchText = ''.obs;

  final podcasts = <Podcast>[].obs;
  final isLoading = false.obs;
  final hasMore = true.obs;
  final currentPage = 1.obs;

  // 所有播客列表，用于搜索
  final allPodcasts = <Podcast>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 初始化时立即加载数据
    initRoutes();
    loadInitialData();
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

  // 加载初始数据
  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      // 模拟加载数据
      await Future.delayed(const Duration(seconds: 1));

      final List<Podcast> initialPodcasts = _generateMockPodcasts();
      podcasts.value = initialPodcasts;
      allPodcasts.value = initialPodcasts;

      currentPage.value = 1;
      hasMore.value = true;
    } catch (e) {
      LogUtil.e('加载发现页数据失败: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 加载更多数据
  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;

    try {
      isLoading.value = true;
      // 模拟加载更多数据
      await Future.delayed(const Duration(seconds: 1));

      final List<Podcast> morePodcasts = _generateMockPodcasts();
      podcasts.addAll(morePodcasts);
      allPodcasts.addAll(morePodcasts);

      currentPage.value++;
      hasMore.value = currentPage.value < 3; // 模拟只有3页数据
    } catch (e) {
      LogUtil.e('加载更多数据失败: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 生成模拟数据
  List<Podcast> _generateMockPodcasts() {
    final List<Podcast> mockPodcasts = [];
    final int baseIndex = (currentPage.value - 1) * 10;

    for (int i = 0; i < 10; i++) {
      mockPodcasts.add(
        Podcast(
          id: '${baseIndex + i}',
          title: '播客 ${baseIndex + i}',
          author: '作者 ${baseIndex + i}',
          cover: 'https://picsum.photos/200/200?random=${baseIndex + i}',
          description: '这是播客 ${baseIndex + i} 的描述',
          subscribers: '${1000 + i}',
          category: '分类${i % 3}',
        ),
      );
    }

    return mockPodcasts;
  }

  // 刷新数据
  Future<void> onRefresh() async {
    hasMore.value = true;
    currentPage.value = 1;
    await loadInitialData();
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
