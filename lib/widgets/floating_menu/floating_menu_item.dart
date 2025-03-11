import 'package:flutter/material.dart';
import 'floating_menu_theme.dart';

class NFloatingMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;

  const NFloatingMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconSize = 24,
    this.fontSize = 10,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
  });

  NFloatingMenuItem copyWith({
    IconData? icon,
    String? label,
    VoidCallback? onTap,
    double? iconSize,
    double? fontSize,
    Color? iconColor,
    Color? textColor,
    Color? backgroundColor,
  }) {
    return NFloatingMenuItem(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      onTap: onTap ?? this.onTap,
      iconSize: iconSize ?? this.iconSize,
      fontSize: fontSize ?? this.fontSize,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuTheme = FloatingMenuTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor ?? menuTheme.itemBackgroundColor,
              borderRadius: BorderRadius.circular(menuTheme.itemBorderRadius),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor ?? menuTheme.iconColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor ?? menuTheme.textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
