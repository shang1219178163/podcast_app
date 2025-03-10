import 'package:flutter/material.dart';
import 'package:podcast_app/extension/widget_ext.dart';
import 'package:podcast_app/models/chat_message.dart';
import 'action_item.dart';

class MessageActionMenu {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show({
    required BuildContext context,
    required ChatMessage message,
    required Offset position,
    required bool isSentByMe,
    required VoidCallback onCopy,
    required VoidCallback onForward,
    required VoidCallback onReply,
    required VoidCallback onMultiSelect,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onRead,
    required VoidCallback onMore,
  }) {
    if (_isVisible) {
      hide();
      return;
    }

    _isVisible = true;
    final isTextMessage = message.type == MessageType.text;
    final isImageMessage = message.type == MessageType.image;

    // 计算菜单位置
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final menuWidth = screenSize.width * 0.84;
    final menuOffset = 20.0;

    // 构建菜单项
    final items = <ActionItem>[];
    if (isTextMessage) {
      items.add(ActionItem(
        icon: Icons.copy,
        label: '复制',
        onTap: () {
          hide();
          onCopy();
        },
      ));
    }
    if (isTextMessage || isImageMessage) {
      items.add(ActionItem(
        icon: Icons.forward,
        label: '转发',
        onTap: () {
          hide();
          onForward();
        },
      ));
    }
    items.addAll([
      ActionItem(
        icon: Icons.reply,
        label: '引用',
        onTap: () {
          hide();
          onReply();
        },
      ),
      ActionItem(
        icon: Icons.select_all,
        label: '多选',
        onTap: () {
          hide();
          onMultiSelect();
        },
      ),
    ]);
    if (isTextMessage) {
      items.add(ActionItem(
        icon: Icons.edit,
        label: '编辑',
        onTap: () {
          hide();
          onEdit();
        },
      ));
    }
    if (isSentByMe) {
      items.add(ActionItem(
        icon: Icons.delete_outline,
        label: '删除',
        onTap: () {
          hide();
          onDelete();
        },
      ));
    }
    if (isTextMessage) {
      items.add(ActionItem(
        icon: Icons.font_download,
        label: '朗读',
        onTap: () {
          hide();
          onRead();
        },
      ));
    }
    items.add(ActionItem(
      icon: Icons.info_outline,
      label: '更多',
      onTap: () {
        hide();
        onMore();
      },
    ));

    // 计算菜单位置
    double dx = position.dx - menuWidth / 2;
    double dy = position.dy - menuOffset;

    // 水平方向边界处理
    if (dx < 8) dx = 8;
    if (dx + menuWidth > screenSize.width - 8) {
      dx = screenSize.width - menuWidth - 8;
    }

    // 垂直方向边界处理
    final topSpace = position.dy - menuOffset;
    if (topSpace < padding.top + 8) {
      dy = position.dy + menuOffset;
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
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    // physics: const NeverScrollableScrollPhysics(),
                    children: items,
                  ).toBorder(color: Colors.red),
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
