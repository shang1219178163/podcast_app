import 'package:get/get.dart';
import '../utils/store_manager.dart';

class UserController extends GetxController {
  final _isLoggedInKey = 'isLoggedIn';
  final _userTokenKey = 'userToken';
  final _userInfoKey = 'userInfo';

  final isLoggedIn = false.obs;
  final userToken = ''.obs;
  final userInfo = <String, dynamic>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    // 初始化时从本地存储加载登录状态
    loadLoginState();
  }

  // 加载登录状态
  void loadLoginState() {
    isLoggedIn.value = StoreManager.getBool(_isLoggedInKey) ?? false;
    userToken.value = StoreManager.getString(_userTokenKey) ?? '';
    userInfo.value = Map<String, dynamic>.from(
      StoreManager.getString(_userInfoKey) != null
          ? Map<String, dynamic>.from(StoreManager.getString(_userInfoKey) as Map<String, dynamic>)
          : {},
    );
  }

  // 保存登录状态
  void saveLoginState({
    required String token,
    required Map<String, dynamic> info,
  }) {
    StoreManager.setBool(_isLoggedInKey, true);
    StoreManager.setString(_userTokenKey, token);
    StoreManager.setString(_userInfoKey, info.toString());

    isLoggedIn.value = true;
    userToken.value = token;
    userInfo.value = info;
  }

  // 清除登录状态
  void clearLoginState() {
    StoreManager.remove(_isLoggedInKey);
    StoreManager.remove(_userTokenKey);
    StoreManager.remove(_userInfoKey);

    isLoggedIn.value = false;
    userToken.value = '';
    userInfo.value = {};
  }

  // 检查是否已登录
  bool get isAuthenticated => isLoggedIn.value && userToken.value.isNotEmpty;
}
