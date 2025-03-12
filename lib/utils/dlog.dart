import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class DLog {
  // 是否启用日志打印
  static bool _enableLog = true;

  // ANSI 颜色代码
  static const String _ansiReset = '\x1B[0m';
  static const String _ansiRed = '\x1B[31m';
  static const String _ansiGreen = '\x1B[32m';
  static const String _ansiYellow = '\x1B[33m';
  static const String _ansiBlue = '\x1B[34m';
  // static const String _ansiGray = '\x1B[37m';

  // Web 控制台颜色样式
  static const String _webRed = 'color: red';
  static const String _webGreen = 'color: #4CAF50';
  static const String _webYellow = 'color: #FFC107';
  static const String _webBlue = 'color: #2196F3';
  // static const String _webGray = 'color: #9E9E9E';

  // 设置是否启用日志
  static void setEnable(bool enable) {
    _enableLog = enable;
  }

  // 打印调试日志
  static void d(dynamic message) {
    _printLog('DEBUG', message, _ansiBlue, _webBlue);
  }

  // 打印信息日志
  static void i(dynamic message) {
    _printLog('INFO', message, _ansiGreen, _webGreen);
  }

  // 打印警告日志
  static void w(dynamic message) {
    _printLog('WARN', message, _ansiYellow, _webYellow);
  }

  // 打印错误日志
  static void e(dynamic message) {
    _printLog('ERROR', message, _ansiRed, _webRed);
  }

  // 获取调用信息
  static (String className, String functionName) _getCallerInfo() {
    try {
      final frames = StackTrace.current.toString().split('\n');
      // 第一帧是当前方法，第二帧是日志方法（d/i/w/e），第三帧是调用者
      if (frames.length > 2) {
        final frame = frames[3]; // 获取调用者的帧
        final match = RegExp(r'#\d+\s+([^\.]+)\.(\w+)').firstMatch(frame);
        if (match != null && match.groupCount >= 2) {
          final className = match.group(1) ?? 'Unknown';
          final functionName = match.group(2) ?? 'unknown';
          return (className, functionName);
        }
      }
    } catch (e) {
      debugPrint('Error getting caller info: $e');
    }
    return ('Unknown', 'unknown');
  }

  // 获取当前平台
  static String _getPlatform() {
    if (kIsWeb) return 'Web';
    try {
      if (Platform.isAndroid) return 'Android';
      if (Platform.isIOS) return 'iOS';
      if (Platform.isMacOS) return 'macOS';
      if (Platform.isWindows) return 'Windows';
      if (Platform.isLinux) return 'Linux';
      if (Platform.isFuchsia) return 'Fuchsia';
    } catch (e) {
      // 如果 Platform 不可用，返回 Unknown
      return 'Unknown';
    }
    return 'Unknown';
  }

  // 内部打印方法
  static void _printLog(String level, dynamic message, String ansiColor, String webColor) {
    if (!_enableLog) return;
    if (!kDebugMode) return;

    final (className, functionName) = _getCallerInfo();
    final DateTime now = DateTime.now();
    final String timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
    final String platform = _getPlatform();
    final String logMessage = '[$timeStr][$level][$platform][$className][$functionName] $message';

    if (kIsWeb) {
      // Web 平台使用 console.log 的样式
      debugPrint(logMessage);
    } else {
      // 移动端和桌面端使用 ANSI 颜色
      final StringBuffer sb = StringBuffer();
      sb.write(ansiColor);
      sb.write(logMessage);
      sb.write(_ansiReset);
      debugPrint(sb.toString());
    }
  }
}
