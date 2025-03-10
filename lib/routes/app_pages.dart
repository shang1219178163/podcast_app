import 'package:get/get.dart';

import '../controllers/player_controller.dart';
import '../controllers/tab_bar_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/podcast_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/subscription_controller.dart';
import '../controllers/chat_controller.dart';

import '../screens/player_page.dart';
import '../screens/tab_bar_page.dart';
import '../screens/podcast_detail_page.dart';
import '../screens/settings_page.dart';
import '../screens/login_page.dart';
import '../screens/home_page.dart';
import '../screens/discover_page.dart';
import '../screens/subscription_page.dart';
import '../screens/profile_page.dart';
import '../screens/user_agreement_page.dart';
import '../screens/privacy_policy_page.dart';
import '../screens/category_detail_page.dart';
import '../screens/notification_settings_page.dart';
import '../screens/volume_settings_page.dart';
import '../screens/timer_settings_page.dart';
import '../screens/playback_speed_settings_page.dart';
import '../screens/personal_profile_page.dart';
import '../screens/account_security_page.dart';
import '../screens/favorites_page.dart';
import '../screens/history_page.dart';
import '../screens/downloads_page.dart';
import '../screens/messages_page.dart';
import '../screens/audio_player_page.dart';
import '../screens/chat_page.dart';
import '../bindings/discover_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoute.login;

  static final routes = [
    GetPage(
      name: AppRoute.login,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        Get.put(LoginController());
      }),
    ),
    GetPage(
      name: AppRoute.tabBar,
      page: () => const TabBarPage(),
      binding: TabBarBinding(),
    ),
    GetPage(
      name: AppRoute.home,
      page: () => const HomePage(),
      binding: BindingsBuilder(() {
        Get.put(PodcastController());
      }),
    ),
    GetPage(
      name: AppRoute.discover,
      page: () => const DiscoverPage(),
      binding: DiscoverBinding(),
    ),
    GetPage(
      name: AppRoute.subscription,
      page: () => const SubscriptionPage(),
      binding: BindingsBuilder(() {
        Get.put(SubscriptionController());
      }),
    ),
    GetPage(
      name: AppRoute.profile,
      page: () => const ProfilePage(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
    ),
    GetPage(
      name: AppRoute.userAgreement,
      page: () => const UserAgreementPage(),
    ),
    GetPage(
      name: AppRoute.privacyPolicy,
      page: () => const PrivacyPolicyPage(),
    ),
    GetPage(
      name: AppRoute.player,
      page: () => const PlayerPage(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: AppRoute.podcastDetail,
      page: () => const PodcastDetailPage(),
      binding: BindingsBuilder(() {
        Get.put(PodcastController());
      }),
    ),
    GetPage(
      name: AppRoute.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoute.categoryDetail,
      page: () => const CategoryDetailPage(),
      binding: BindingsBuilder(() {
        Get.put(CategoryController());
        Get.put(PodcastController());
      }),
    ),
    GetPage(
      name: AppRoute.notificationSettings,
      page: () => const NotificationSettingsPage(),
    ),
    GetPage(
      name: AppRoute.volumeSettings,
      page: () => const VolumeSettingsPage(),
    ),
    GetPage(
      name: AppRoute.timerSettings,
      page: () => const TimerSettingsPage(),
    ),
    GetPage(
      name: AppRoute.playbackSpeedSettings,
      page: () => const PlaybackSpeedSettingsPage(),
    ),
    GetPage(
      name: AppRoute.personalProfile,
      page: () => const PersonalProfilePage(),
    ),
    GetPage(
      name: AppRoute.accountSecurity,
      page: () => const AccountSecurityPage(),
    ),
    GetPage(
      name: AppRoute.favorites,
      page: () => const FavoritesPage(),
    ),
    GetPage(
      name: AppRoute.history,
      page: () => const HistoryPage(),
    ),
    GetPage(
      name: AppRoute.downloads,
      page: () => const DownloadsPage(),
    ),
    GetPage(
      name: AppRoute.messages,
      page: () => const MessagesPage(),
    ),
    GetPage(
      name: AppRoute.audioPlayer,
      page: () => const AudioPlayerPage(),
    ),
    GetPage(
      name: AppRoute.chat,
      page: () => const ChatPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChatController>(() => ChatController(
              chatId: (Get.arguments?['chatId'] as String?) ?? '',
              chatTitle: (Get.arguments?['chatTitle'] as String?) ?? '',
              currentUserId: (Get.arguments?['currentUserId'] as String?) ?? '',
            ));
      }),
    ),
  ];
}

class TabBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NTabBarController>(() => NTabBarController());
  }
}

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerController>(() => PlayerController());
  }
}

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
