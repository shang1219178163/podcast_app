import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  final subscribedPodcasts = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSubscribedPodcasts();
  }

  Future<void> loadSubscribedPodcasts() async {
    isLoading.value = true;
    try {
      // TODO: 从API加载订阅的播客列表
      await Future.delayed(const Duration(seconds: 1)); // 模拟加载
      subscribedPodcasts.value = [
        {
          'id': '1',
          'title': '未来科技浪潮',
          'author': '科技早知道',
          'cover': 'https://example.com/cover1.jpg',
          'description': '探讨最新科技发展趋势',
          'lastUpdate': '2024-03-20',
        },
        {
          'id': '2',
          'title': '商业洞察',
          'author': '商业周刊',
          'cover': 'https://example.com/cover2.jpg',
          'description': '深度解析商业现象',
          'lastUpdate': '2024-03-19',
        },
      ];
    } catch (e) {
      Get.snackbar(
        '错误',
        '加载订阅列表失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> subscribeToPodcast(String podcastId) async {
    try {
      // TODO: 调用API订阅播客
      await Future.delayed(const Duration(seconds: 1)); // 模拟订阅
      Get.snackbar(
        '成功',
        '订阅成功',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '错误',
        '订阅失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> unsubscribeFromPodcast(String podcastId) async {
    try {
      // TODO: 调用API取消订阅
      await Future.delayed(const Duration(seconds: 1)); // 模拟取消订阅
      Get.snackbar(
        '成功',
        '已取消订阅',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '错误',
        '取消订阅失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
