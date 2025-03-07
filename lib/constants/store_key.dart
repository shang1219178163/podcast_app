/// 存储键名枚举
enum StoreKey {
  // 用户相关
  isLoggedIn(key: 'is_logged_in', logined: true, desc: '用户是否已登录'),
  userId(key: 'user_id', logined: true, desc: '用户ID'),
  userToken(key: 'user_token', logined: true, desc: '用户令牌'),
  userProfile(key: 'user_profile', logined: true, desc: '用户信息'),

  // 设置相关
  agreedToTerms(key: 'agreed_to_terms', logined: false, desc: '是否同意用户协议'),
  theme(key: 'theme', logined: false, desc: '主题设置'),
  language(key: 'language', logined: false, desc: '语言设置'),

  // 播放器相关
  playbackSpeed(key: 'playback_speed', logined: false, desc: '播放速度'),
  volume(key: 'volume', logined: false, desc: '音量'),
  autoPlay(key: 'auto_play', logined: false, desc: '自动播放'),

  // 缓存相关
  cacheSize(key: 'cache_size', logined: false, desc: '缓存大小'),
  cacheExpiration(key: 'cache_expiration', logined: false, desc: '缓存过期时间'),

  // 通知相关
  notificationsEnabled(key: 'notifications_enabled', logined: false, desc: '通知开关'),
  notificationTypes(key: 'notification_types', logined: false, desc: '通知类型'),
  lastLoginTime(key: 'last_login_time', logined: true, desc: '最后登录时间');

  final String key;
  final bool logined;
  final String desc;

  const StoreKey({
    required this.key,
    required this.logined,
    required this.desc,
  });

  @override
  String toString() => 'StoreKey{name: $name, key: $key, logined: $logined, desc: $desc}';
}
