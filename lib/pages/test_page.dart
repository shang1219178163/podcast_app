import 'package:flutter/material.dart';
import 'package:podcast_app/extension/widget_ext.dart';
import 'package:podcast_app/widgets/floating_menu.dart';

import '../widgets/floating_menu/index.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试页面'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildWrapView(context),
              const SizedBox(height: 20),
              GestureDetector(
                onTapDown: (details) => _showMessageMenu(context, details: details),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.blue),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Text('显示文本消息菜单'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWrapView(BuildContext context) {
    // 计算菜单位置
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final menuWidth = screenSize.width * 0.84;
    const menuOffset = 20.0;

    // 构建菜单项
    final items = <FloatingMenuItem>[];
    items.add(FloatingMenuItem(
      icon: Icons.copy,
      label: '复制',
      onTap: () {},
    ));

    items.add(FloatingMenuItem(
      icon: Icons.forward,
      label: '转发',
      onTap: () {},
    ));

    items.addAll([
      FloatingMenuItem(
        icon: Icons.reply,
        label: '引用',
        onTap: () {},
      ),
      FloatingMenuItem(
        icon: Icons.select_all,
        label: '多选',
        onTap: () {},
      ),
    ]);

    items.add(FloatingMenuItem(
      icon: Icons.edit,
      label: '编辑',
      onTap: () {},
    ));

    items.add(FloatingMenuItem(
      icon: Icons.delete_outline,
      label: '删除',
      onTap: () {},
    ));

    items.add(FloatingMenuItem(
      icon: Icons.font_download,
      label: '朗读',
      onTap: () {},
    ));

    items.add(FloatingMenuItem(
      icon: Icons.info_outline,
      label: '更多',
      onTap: () {},
    ));

    // 计算每个项目的宽度
    final itemWidth = (menuWidth - 16 * 2 - 12 * 3) / 4; // 总宽度减去padding和间距，除以列数

    return TweenAnimationBuilder<double>(
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
        color: Colors.green,
        child: Container(
          width: menuWidth,
          padding: const EdgeInsets.all(16),
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
            spacing: 12, // 水平间距
            runSpacing: 12, // 垂直间距
            children: items.map((item) {
              return SizedBox(
                width: itemWidth,
                child: item,
              );
            }).toList(),
          ).toBorder(color: Colors.red),
        ),
      ),
    );
  }

  void _showMessageMenu(
    BuildContext context, {
    required TapDownDetails details,
    VoidCallback? onCopy,
    VoidCallback? onForward,
    VoidCallback? onReply,
    VoidCallback? onMultiSelect,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onRead,
    VoidCallback? onMore,
  }) {
    void hide() {
      NFloatingMenu.hide();
    }

    // 构建菜单项
    final items = <NFloatingMenuItem>[];
    items.add(NFloatingMenuItem(
      icon: Icons.copy,
      label: '复制',
      onTap: () {
        hide();
        onCopy?.call();
      },
    ));

    items.add(NFloatingMenuItem(
      icon: Icons.forward,
      label: '转发',
      onTap: () {
        hide();
        onForward?.call();
      },
    ));

    // if (onReply != null) {
    items.add(NFloatingMenuItem(
      icon: Icons.reply,
      label: '引用',
      onTap: () {
        hide();
        onReply?.call();
      },
    ));
    // }

    // if (onMultiSelect != null) {
    items.add(NFloatingMenuItem(
      icon: Icons.select_all,
      label: '多选',
      onTap: () {
        hide();
        onMultiSelect?.call();
      },
    ));
    // }

    // if (onEdit != null) {
    items.add(NFloatingMenuItem(
      icon: Icons.edit,
      label: '编辑',
      onTap: () {
        hide();
        onEdit?.call();
      },
    ));
    // }

    // if (isSentByMe && onDelete != null) {
    items.add(NFloatingMenuItem(
      icon: Icons.delete_outline,
      label: '删除',
      onTap: () {
        hide();
        onDelete?.call();
      },
    ));
    // }

    // if (isTextMessage && onRead != null) {
    items.add(NFloatingMenuItem(
      icon: Icons.font_download,
      label: '朗读',
      onTap: () {
        hide();
        onRead?.call();
      },
    ));
    // }

    // if (onMore != null) {
    items.add(NFloatingMenuItem(
      icon: Icons.info_outline,
      label: '更多',
      onTap: () {
        hide();
        onMore?.call();
      },
    ));
    // }
    // 显示菜单
    NFloatingMenu.show(
      context: context,
      position: details.globalPosition,
      items: items,
    );
  }
}
