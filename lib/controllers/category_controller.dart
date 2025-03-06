import 'package:get/get.dart';

class CategoryController extends GetxController {
  final categories = <Map<String, dynamic>>[].obs;
  final currentCategory = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      // TODO: 从API加载分类列表
      await Future.delayed(const Duration(seconds: 1)); // 模拟加载
      categories.value = [
        {
          'id': '1',
          'name': '音乐',
          'icon': 'music_note',
        },
        {
          'id': '2',
          'name': '科技',
          'icon': 'science',
        },
        {
          'id': '3',
          'name': '商业',
          'icon': 'business',
        },
        {
          'id': '4',
          'name': '心理',
          'icon': 'psychology',
        },
        {
          'id': '5',
          'name': '游戏',
          'icon': 'sports_esports',
        },
        {
          'id': '6',
          'name': '影视',
          'icon': 'movie',
        },
        {
          'id': '7',
          'name': '教育',
          'icon': 'school',
        },
        {
          'id': '8',
          'name': '体育',
          'icon': 'sports_soccer',
        },
      ];
    } catch (e) {
      Get.snackbar(
        '错误',
        '加载分类列表失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setCurrentCategory(Map<String, dynamic> category) {
    currentCategory.value = category;
  }

  void clearCurrentCategory() {
    currentCategory.value = null;
  }
}
