import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
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
    );
  }
}
