import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/extension/widget_ext.dart';
import '../models/chat_message.dart';
import '../widgets/message_action_menu/index.dart';

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
              // 测试按钮
              ElevatedButton(
                onPressed: () {
                  // 创建一个测试消息
                  final message = ChatMessage(
                    id: 'test_1',
                    content: '这是一条测试消息',
                    senderId: 'user_1',
                    senderName: '测试用户',
                    senderAvatar: 'https://via.placeholder.com/40',
                    type: MessageType.text,
                    timestamp: DateTime.now(),
                  );

                  // 显示菜单
                  MessageActionMenu.show(
                    context: context,
                    message: message,
                    position: const Offset(200, 300),
                    isSentByMe: true,
                    onCopy: () => Get.snackbar('提示', '复制消息'),
                    onForward: () => Get.snackbar('提示', '转发消息'),
                    onReply: () => Get.snackbar('提示', '引用消息'),
                    onMultiSelect: () => Get.snackbar('提示', '多选消息'),
                    onEdit: () => Get.snackbar('提示', '编辑消息'),
                    onDelete: () => Get.snackbar('提示', '删除消息'),
                    onRead: () => Get.snackbar('提示', '朗读消息'),
                    onMore: () => Get.snackbar('提示', '更多操作'),
                  );
                },
                child: const Text('显示文本消息菜单'),
              ),
              const SizedBox(height: 20),
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
    final menuOffset = 20.0;

    // 构建菜单项
    final items = <ActionItem>[];
    items.add(ActionItem(
      icon: Icons.copy,
      label: '复制',
      onTap: () {},
    ));

    items.add(ActionItem(
      icon: Icons.forward,
      label: '转发',
      onTap: () {},
    ));

    items.addAll([
      ActionItem(
        icon: Icons.reply,
        label: '引用',
        onTap: () {},
      ),
      ActionItem(
        icon: Icons.select_all,
        label: '多选',
        onTap: () {},
      ),
    ]);

    items.add(ActionItem(
      icon: Icons.edit,
      label: '编辑',
      onTap: () {},
    ));

    items.add(ActionItem(
      icon: Icons.delete_outline,
      label: '删除',
      onTap: () {},
    ));

    items.add(ActionItem(
      icon: Icons.font_download,
      label: '朗读',
      onTap: () {},
    ));

    items.add(ActionItem(
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
}
