import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_pages.dart';
import '../utils/store_manager.dart';

class LoginController extends GetxController {
  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final agreedToTerms = false.obs;
  final _agreedToTermsKey = 'agreedToTerms';

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    // 从本地存储加载协议勾选状态
    agreedToTerms.value = StoreManager.getBool(_agreedToTermsKey) ?? false;
  }

  // 检查登录状态
  Future<void> checkLoginStatus() async {
    isLoggedIn.value = StoreManager.getBool('isLoggedIn') ?? false;
  }

  // 微信登录
  Future<void> loginWithWeChat() async {
    if (!agreedToTerms.value) {
      Get.snackbar(
        '提示',
        '请先同意用户协议和隐私政策',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      // TODO: 实现微信登录
      await Future.delayed(const Duration(seconds: 2)); // 模拟登录过程

      await StoreManager.setBool('isLoggedIn', true);
      isLoggedIn.value = true;

      await Get.offAllNamed(AppRoute.tabBar);
    } catch (e) {
      Get.snackbar(
        '错误',
        '登录失败，请重试',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 手机号登录
  Future<void> loginWithPhone() async {
    if (!agreedToTerms.value) {
      Get.snackbar(
        '提示',
        '请先同意用户协议和隐私政策',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      // TODO: 实现手机号登录
      await Future.delayed(const Duration(seconds: 1)); // 模拟登录过程

      await StoreManager.setBool('isLoggedIn', true);
      isLoggedIn.value = true;

      await Get.offAllNamed(AppRoute.tabBar);
    } catch (e) {
      Get.snackbar(
        '错误',
        '登录失败，请重试',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 退出登录
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await StoreManager.setBool('isLoggedIn', false);
      isLoggedIn.value = false;
      await Get.offAllNamed(AppRoute.login);
    } catch (e) {
      Get.snackbar(
        '错误',
        '退出失败，请重试',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 切换用户协议同意状态
  void toggleAgreement() {
    agreedToTerms.value = !agreedToTerms.value;
    // 保存协议勾选状态到本地存储
    StoreManager.setBool(_agreedToTermsKey, agreedToTerms.value);
  }

  // 打开用户协议
  void openUserAgreement() {
    Get.toNamed(AppRoute.userAgreement);
  }

  // 打开隐私政策
  void openPrivacyPolicy() {
    Get.toNamed(AppRoute.privacyPolicy);
  }
}
