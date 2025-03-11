import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_provider.dart';

class ThemeBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isDarkMode) builder;

  const ThemeBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeProvider>(
      builder: (controller) => builder(context, controller.isDarkMode),
    );
  }
}
