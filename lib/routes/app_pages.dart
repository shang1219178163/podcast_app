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
import '../controllers/survey_controller.dart';

import '../pages/player_page.dart';
import '../pages/tab_bar_page.dart';
import '../pages/podcast_detail_page.dart';
import '../pages/settings_page.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/discover_page.dart';
import '../pages/subscription_page.dart';
import '../pages/profile_page.dart';
import '../pages/user_agreement_page.dart';
import '../pages/privacy_policy_page.dart';
import '../pages/category_detail_page.dart';
import '../pages/notification_settings_page.dart';
import '../pages/volume_settings_page.dart';
import '../pages/timer_settings_page.dart';
import '../pages/playback_speed_settings_page.dart';
import '../pages/personal_profile_page.dart';
import '../pages/account_security_page.dart';
import '../pages/favorites_page.dart';
import '../pages/history_page.dart';
import '../pages/downloads_page.dart';
import '../pages/messages_page.dart';
import '../pages/audio_player_page.dart';
import '../pages/chat_page.dart';
import '../pages/test_page.dart';
import '../pages/hospital_management_page.dart';
import '../pages/survey_page.dart';
import '../bindings/discover_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoute.home;

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
    GetPage(
      name: AppRoute.test,
      page: () => const TestPage(),
      binding: null,
    ),
    GetPage(
      name: AppRoute.hospitalManagement,
      page: () => const HospitalManagementPage(),
    ),
    GetPage(
      name: AppRoute.survey,
      page: () => const SurveyPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SurveyController());
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
