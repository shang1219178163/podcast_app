import 'package:flutter/material.dart';
import 'floating_menu_item.dart';
import 'floating_menu_theme.dart';

class NFloatingMenu {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show({
    required BuildContext context,
    required Offset position,
    required List<NFloatingMenuItem> items,
    double menuWidth = 0.84, // 菜单宽度占屏幕宽度的比例
    double menuOffset = 20.0, // 菜单与点击位置的偏移
  }) {
    if (_isVisible) {
      hide();
      return;
    }

    _isVisible = true;

    // 获取主题
    final menuTheme = FloatingMenuTheme.of(context);

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
                color: menuTheme.maskColor,
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
                  padding: menuTheme.padding,
                  decoration: BoxDecoration(
                    color: menuTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(menuTheme.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: menuTheme.shadowColor,
                        blurRadius: menuTheme.elevation,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 菜单项
                      Wrap(
                        spacing: menuTheme.spacing,
                        runSpacing: menuTheme.runSpacing,
                        children: items.map((item) {
                          return SizedBox(
                            width: itemWidth,
                            child: item.copyWith(
                              backgroundColor: menuTheme.itemBackgroundColor,
                              iconColor: menuTheme.iconColor,
                              textColor: menuTheme.textColor,
                              iconSize: menuTheme.iconSize,
                              fontSize: menuTheme.fontSize,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
