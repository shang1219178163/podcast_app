import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../utils/store_manager.dart';
import '../utils/dlog.dart';
import '../constants/store_key.dart';

class LoginController extends GetxController {
  static const String _tag = 'LoginController';
  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final agreedToTerms = false.obs;

  @override
  void onInit() {
    super.onInit();
    DLog.i('Initializing LoginController');
    checkLoginStatus();
    // 从本地存储加载协议勾选状态
    agreedToTerms.value = StoreManager.getBool(StoreKey.agreedToTerms.name) ?? false;
  }

  // 检查登录状态
  Future<void> checkLoginStatus() async {
    DLog.d('Checking login status');
    isLoggedIn.value = StoreManager.getBool(StoreKey.isLoggedIn.name) ?? false;
    DLog.d('Login status: ${isLoggedIn.value}');
  }

  // 微信登录
  Future<void> loginWithWeChat() async {
    if (!agreedToTerms.value) {
      DLog.w('User has not agreed to terms');
      Get.snackbar(
        '提示',
        '请先同意用户协议和隐私政策',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      DLog.i('Attempting WeChat login');
      isLoading.value = true;
      // TODO: 实现微信登录
      await Future.delayed(const Duration(seconds: 2)); // 模拟登录过程

      // 设置登录状态和用户信息
      await StoreManager.setBool(StoreKey.isLoggedIn.name, true);
      await StoreManager.setString(StoreKey.userId.name, 'wechat_user_id');
      await StoreManager.setString(StoreKey.userToken.name, 'wechat_token');

      isLoggedIn.value = true;
      DLog.i('Login successful');

      await Get.offAllNamed(AppRoute.tabBar);
    } catch (e) {
      DLog.e('Login failed: $e');
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
      DLog.w('User has not agreed to terms');
      Get.snackbar(
        '提示',
        '请先同意用户协议和隐私政策',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      DLog.i('Attempting phone login');
      isLoading.value = true;
      // TODO: 实现手机号登录
      await Future.delayed(const Duration(seconds: 1)); // 模拟登录过程

      // 设置登录状态和用户信息
      await StoreManager.setBool(StoreKey.isLoggedIn.name, true);
      await StoreManager.setString(StoreKey.userId.name, 'phone_user_id');
      await StoreManager.setString(StoreKey.userToken.name, 'phone_token');

      isLoggedIn.value = true;
      DLog.i('Login successful');

      await Get.offAllNamed(AppRoute.tabBar);
    } catch (e) {
      DLog.e('Login failed: $e');
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
      DLog.i('Logging out');
      isLoading.value = true;
      await StoreManager.clearLoginRequiredData();
      isLoggedIn.value = false;
      DLog.i('Logout successful');
      await Get.offAllNamed(AppRoute.login);
    } catch (e) {
      DLog.e('Logout failed: $e');
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
    DLog.d('Toggling agreement status');
    agreedToTerms.value = !agreedToTerms.value;
    // 保存协议勾选状态到本地存储
    StoreManager.setBool(StoreKey.agreedToTerms.name, agreedToTerms.value);
  }

  // 打开用户协议
  void openUserAgreement() {
    DLog.d('Opening user agreement');
    Get.toNamed(AppRoute.userAgreement);
  }

  // 打开隐私政策
  void openPrivacyPolicy() {
    DLog.d('Opening privacy policy');
    Get.toNamed(AppRoute.privacyPolicy);
  }
}
