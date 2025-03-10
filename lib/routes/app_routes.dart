part of 'app_pages.dart';

abstract class AppRoute {
  static const login = '/login';
  static const tabBar = '/tabBar';
  static const home = '/home';
  static const discover = '/discover';
  static const subscription = '/subscription';
  static const profile = '/profile';
  static const userAgreement = '/userAgreement';
  static const privacyPolicy = '/privacyPolicy';
  static const player = '/player';
  static const podcastDetail = '/podcastDetail';
  static const settings = '/settings';
  static const categoryDetail = '/categoryDetail';
  static const notificationSettings = '/notificationSettings';
  static const volumeSettings = '/volumeSettings';
  static const timerSettings = '/timerSettings';
  static const playbackSpeedSettings = '/playbackSpeedSettings';
  static const personalProfile = '/personalProfile';
  static const accountSecurity = '/accountSecurity';
  static const favorites = '/favorites';
  static const history = '/history';
  static const downloads = '/downloads';
  static const messages = '/messages';
  static const register = '/register';
  static const audioPlayer = '/audioPlayer';
  static const chat = '/chat';

  static List<String> get values => [
        login,
        tabBar,
        home,
        discover,
        subscription,
        profile,
        userAgreement,
        privacyPolicy,
        player,
        podcastDetail,
        settings,
        categoryDetail,
        notificationSettings,
        volumeSettings,
        timerSettings,
        playbackSpeedSettings,
        personalProfile,
        accountSecurity,
        favorites,
        history,
        downloads,
        messages,
        audioPlayer,
        chat,
      ];
}
