import 'package:flutter/material.dart';
import 'package:podcast_app/widgets/floating_menu/floating_menu_theme.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF07C160),
 
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF07C160),
      secondary: const Color(0xFF07C160),
      surface: Colors.white,
      background: Colors.grey[50]!,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFF07C160),
      inactiveTrackColor: Colors.grey[300],
      thumbColor: const Color(0xFF07C160),
      overlayColor: const Color(0xFF07C160).withOpacity(0.1),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF07C160),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
    extensions: [
      FloatingMenuTheme(
        backgroundColor: Colors.white,
        itemBackgroundColor: Colors.white,
        iconColor: Colors.black87,
        textColor: Colors.black87,
        shadowColor: Colors.black.withOpacity(0.1),
        maskColor: Colors.transparent,
      ),
    ],
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.dark,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      enableFeedback: false,
    ),
    cardTheme: const CardTheme(
      clipBehavior: Clip.none,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C1C1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFF07C160),
      inactiveTrackColor: Colors.grey[800],
      thumbColor: const Color(0xFF07C160),
      overlayColor: const Color(0xFF07C160).withOpacity(0.1),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF07C160),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    extensions: [
      FloatingMenuTheme(
        backgroundColor: const Color(0xFF2C2C2E),
        itemBackgroundColor: const Color(0xFF3A3A3C),
        iconColor: Colors.white,
        textColor: Colors.white70,
        shadowColor: Colors.black.withOpacity(0.3),
        maskColor: Colors.black.withOpacity(0.1),
      ),
    ],
  );
}
