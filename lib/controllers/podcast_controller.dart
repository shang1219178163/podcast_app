import 'package:get/get.dart';

class PodcastController extends GetxController {
  final currentPodcast = Rxn<Map<String, dynamic>>();
  final podcastList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPodcasts();
  }

  Future<void> loadPodcasts() async {
    isLoading.value = true;
    try {
      // TODO: 从API加载播客列表
      await Future.delayed(const Duration(seconds: 1)); // 模拟加载
      podcastList.value = [
        {
          'id': '1',
          'title': '未来科技浪潮',
          'author': '科技早知道',
          'cover': 'https://example.com/cover1.jpg',
          'description': '探讨最新科技发展趋势',
        },
        // 添加更多播客数据
      ];
    } catch (e) {
      Get.snackbar(
        '错误',
        '加载播客列表失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setCurrentPodcast(Map<String, dynamic> podcast) {
    currentPodcast.value = podcast;
  }

  void clearCurrentPodcast() {
    currentPodcast.value = null;
  }
}
