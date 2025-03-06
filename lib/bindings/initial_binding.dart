import 'package:get/get.dart';
import 'package:podcast_app/controllers/audio_player_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/player_controller.dart';
import '../controllers/tab_bar_controller.dart';
import '../controllers/user_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // // 初始化所有需要的控制器
      Get.put(AudioPlayerController());
    Get.put(UserController());
    Get.putNew(SettingsController());
    Get.putNew(PlayerController());
    Get.putNew(NTabBarController());
    Get.putNew(AudioPlayerController());

  }
}

extension InstExt on GetInterface {
  /// 返回一个实例，如果实例不存在，则创建一个实例
  S putNew<S>(S dependency, {String? tag, bool permanent = false}) {
    if (GetInstance().isRegistered<S>(tag: tag)) {
      return GetInstance().find<S>(tag: tag);
    }

    return GetInstance().put<S>(dependency, tag: tag, permanent: permanent);
  }
}
