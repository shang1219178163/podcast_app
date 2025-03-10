import 'package:flutter/material.dart';
import 'package:podcast_app/extension/widget_ext.dart';

/// 浮层菜单弹窗
class FloatingMenu {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show({
    required BuildContext context,
    required Offset position,
    required List<FloatingMenuItem> items,
    double menuWidth = 0.84, // 菜单宽度占屏幕宽度的比例
    double menuOffset = 20.0, // 菜单与点击位置的偏移
  }) {
    if (_isVisible) {
      hide();
      return;
    }

    _isVisible = true;

    // 计算菜单位置
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final width = menuWidth * screenSize.width;

    // 计算菜单位置
    double dx = position.dx - width / 2;
    double dy = position.dy - menuOffset;

    // 水平方向边界处理
    if (dx < 8) dx = 8;
    if (dx + width > screenSize.width - 8) {
      dx = screenSize.width - width - 8;
    }

    // 计算菜单高度
    const numOfRow = 4;
    const spacing = 12.0;
    const runSpacing = 12.0;

    const aPadding = EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    );

    final itemWidth = (width - aPadding.left - aPadding.right - spacing * (numOfRow - 1)) / numOfRow;
    final itemHeight = itemWidth * 1.2; // 估算每个项目的高度
    final rowCount = (items.length / numOfRow).ceil();
    final menuHeight = aPadding.top + aPadding.bottom + (itemHeight + runSpacing) * rowCount - runSpacing;

    // 垂直方向边界处理
    final topSpace = position.dy - menuOffset - menuHeight;
    if (topSpace < padding.top + 8) {
      // 上方空间不足，显示在下方
      dy = position.dy + menuOffset;
    } else {
      // 上方空间足够，显示在上方
      dy = position.dy - menuOffset - menuHeight;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 背景遮罩
          Positioned.fill(
            child: GestureDetector(
              onTap: hide,
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),

          // 菜单内容
          Positioned(
            left: dx,
            top: dy,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: width,
                  padding: aPadding,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Wrap(
                    spacing: spacing, // 水平间距
                    runSpacing: runSpacing, // 垂直间距
                    children: items.map((item) {
                      return SizedBox(
                        width: itemWidth,
                        child: item,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }
}

class FloatingMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;

  const FloatingMenuItem({
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

  @override
  Widget build(BuildContext context) {
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
              color: backgroundColor ?? Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor ?? Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor ?? Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
