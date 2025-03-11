import 'package:flutter/material.dart';
import 'dart:ui' as ui show lerpDouble;

@immutable
class FloatingMenuTheme extends ThemeExtension<FloatingMenuTheme> {
  final Color backgroundColor;
  final Color itemBackgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color shadowColor;
  final Color maskColor;
  final double borderRadius;
  final double itemBorderRadius;
  final double elevation;
  final EdgeInsets padding;
  final double spacing;
  final double runSpacing;
  final double itemWidth;
  final double itemHeight;
  final double iconSize;
  final double fontSize;

  const FloatingMenuTheme({
    required this.backgroundColor,
    required this.itemBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.shadowColor,
    required this.maskColor,
    this.borderRadius = 12,
    this.itemBorderRadius = 12,
    this.elevation = 8,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 12,
    this.runSpacing = 12,
    this.itemWidth = 48,
    this.itemHeight = 48,
    this.iconSize = 24,
    this.fontSize = 10,
  });

  @override
  FloatingMenuTheme copyWith({
    Color? backgroundColor,
    Color? itemBackgroundColor,
    Color? iconColor,
    Color? textColor,
    Color? shadowColor,
    Color? maskColor,
    double? borderRadius,
    double? itemBorderRadius,
    double? elevation,
    EdgeInsets? padding,
    double? spacing,
    double? runSpacing,
    double? itemWidth,
    double? itemHeight,
    double? iconSize,
    double? fontSize,
  }) {
    return FloatingMenuTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      itemBackgroundColor: itemBackgroundColor ?? this.itemBackgroundColor,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      shadowColor: shadowColor ?? this.shadowColor,
      maskColor: maskColor ?? this.maskColor,
      borderRadius: borderRadius ?? this.borderRadius,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      itemWidth: itemWidth ?? this.itemWidth,
      itemHeight: itemHeight ?? this.itemHeight,
      iconSize: iconSize ?? this.iconSize,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  FloatingMenuTheme lerp(ThemeExtension<FloatingMenuTheme>? other, double t) {
    if (other is! FloatingMenuTheme) {
      return this;
    }
    return FloatingMenuTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      itemBackgroundColor: Color.lerp(itemBackgroundColor, other.itemBackgroundColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      maskColor: Color.lerp(maskColor, other.maskColor, t)!,
      borderRadius: ui.lerpDouble(borderRadius, other.borderRadius, t)!,
      itemBorderRadius: ui.lerpDouble(itemBorderRadius, other.itemBorderRadius, t)!,
      elevation: ui.lerpDouble(elevation, other.elevation, t)!,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      spacing: ui.lerpDouble(spacing, other.spacing, t)!,
      runSpacing: ui.lerpDouble(runSpacing, other.runSpacing, t)!,
      itemWidth: ui.lerpDouble(itemWidth, other.itemWidth, t)!,
      itemHeight: ui.lerpDouble(itemHeight, other.itemHeight, t)!,
      iconSize: ui.lerpDouble(iconSize, other.iconSize, t)!,
      fontSize: ui.lerpDouble(fontSize, other.fontSize, t)!,
    );
  }

  // 亮色主题
  static FloatingMenuTheme light = FloatingMenuTheme(
    backgroundColor: Colors.white,
    itemBackgroundColor: Colors.grey[100]!,
    iconColor: Colors.black87,
    textColor: Colors.black87,
    shadowColor: Colors.black.withOpacity(0.1),
    maskColor: Colors.transparent,
  );

  // 暗色主题
  static FloatingMenuTheme dark = FloatingMenuTheme(
    backgroundColor: const Color(0xff4d4d4d),
    itemBackgroundColor: Colors.black.withOpacity(0.05),
    iconColor: Colors.white70,
    textColor: Colors.white70,
    shadowColor: Colors.black.withOpacity(0.3),
    maskColor: Colors.transparent,
  );

  static FloatingMenuTheme of(BuildContext context) {
    return Theme.of(context).extension<FloatingMenuTheme>() ?? light;
  }
}
