import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userProfile = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;
  final statistics = {
    'favorites': 0.obs,
    'history': 0.obs,
    'downloads': 0.obs,
    'messages': 0.obs,
  };

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    loadStatistics();
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    try {
      // TODO: 从API加载用户资料
      await Future.delayed(const Duration(seconds: 1)); // 模拟加载
      userProfile.value = {
        'id': '1',
        'nickname': '用户昵称',
        'avatar': 'https://example.com/avatar.jpg',
        'bio': '个人简介',
      };
    } catch (e) {
      Get.snackbar(
        '错误',
        '加载用户资料失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStatistics() async {
    try {
      // TODO: 从API加载统计数据
      await Future.delayed(const Duration(seconds: 1)); // 模拟加载
      statistics['favorites']?.value = 12;
      statistics['history']?.value = 45;
      statistics['downloads']?.value = 8;
      statistics['messages']?.value = 3;
    } catch (e) {
      Get.snackbar(
        '错误',
        '加载统计数据失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateProfile(Map<String, dynamic> newProfile) async {
    isLoading.value = true;
    try {
      // TODO: 调用API更新用户资料
      await Future.delayed(const Duration(seconds: 1)); // 模拟更新
      userProfile.value = newProfile;
      Get.snackbar(
        '成功',
        '更新用户资料成功',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '错误',
        '更新用户资料失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
