import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_input_widget.dart';
import '../widgets/chat_message_item.dart';
import '../models/chat_message.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        // backgroundColor: const Color(0xFF2C2C2C),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.chatTitle,
              style: TextStyle(
                fontSize: 17,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (controller.isTyping.value)
              Text(
                '对方正在输入...',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => _showMoreActions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final showTime = _shouldShowTime(index);
                  return Column(
                    children: [
                      if (showTime && message.timestamp != null) _buildTimeStamp(message.timestamp!),
                      ChatMessageItem(
                        message: message,
                        debugInfo: 'senderId: ${message.senderId ?? "null"}',
                        onTapAvatar: message.senderId != null ? () => controller.onTapAvatar(message.senderId!) : null,
                        onTapMessage: () => controller.onTapMessage(message),
                        onCopy: () => controller.copyMessage(message),
                        onForward: () => controller.startMultiSelect(message),
                        onReply: () => controller.replyMessage(message),
                        onMultiSelect: () => controller.startMultiSelect(message),
                        onEdit: () {
                          // TODO: 实现编辑功能
                        },
                        onDelete: () => controller.deleteMessage(message),
                        onRead: () => controller.readMessage(message),
                        onMore: () {
                          // TODO: 显示更多选项
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // 输入区域
          ChatInputWidget(
            onSendText: controller.sendTextMessage,
            onSendVoice: controller.sendVoiceMessage,
            onSendImage: controller.sendImageMessage,
            onSendEmoji: controller.sendEmojiMessage,
          ),
        ],
      ),
    );
  }

  bool _shouldShowTime(int index) {
    if (index == controller.messages.length - 1) return true;
    final currentMsg = controller.messages[index];
    final previousMsg = controller.messages[index + 1];

    if (currentMsg.timestamp == null || previousMsg.timestamp == null) {
      return false;
    }

    return currentMsg.timestamp!.difference(previousMsg.timestamp!).inMinutes > 5;
  }

  Widget _buildTimeStamp(DateTime time) {
    final theme = Theme.of(Get.context!);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _formatTime(time),
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.year == now.year) {
      if (time.month == now.month && time.day == now.day) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      }
      return '${time.month}月${time.day}日 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.year}年${time.month}月${time.day}日 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showMoreActions(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              Icons.person_add,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              '添加成员',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Get.back();
              controller.addMember();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              '搜索聊天记录',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Get.back();
              controller.searchMessages();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.error,
            ),
            title: Text(
              '清空聊天记录',
              style: TextStyle(
                color: theme.colorScheme.error,
              ),
            ),
            onTap: () {
              Get.back();
              controller.clearMessages();
            },
          ),
        ],
      ),
    );
  }

  void _showMessageActions(BuildContext context, ChatMessage message) {
    final theme = Theme.of(context);
    final isSentByMe = message.senderId == controller.currentUserId;
    final isTextMessage = message.type == MessageType.text;
    final isImageMessage = message.type == MessageType.image;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部灰条
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 操作按钮网格
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  if (isTextMessage) ...[
                    _buildActionItem(
                      context: context,
                      icon: Icons.copy,
                      label: '复制',
                      onTap: () {
                        Get.back();
                        controller.copyMessage(message);
                      },
                    ),
                  ],
                  if (isTextMessage || isImageMessage) ...[
                    _buildActionItem(
                      context: context,
                      icon: Icons.forward,
                      label: '转发',
                      onTap: () {
                        Get.back();
                        controller.startMultiSelect(message);
                      },
                    ),
                  ],
                  _buildActionItem(
                    context: context,
                    icon: Icons.reply,
                    label: '引用',
                    onTap: () {
                      Get.back();
                      controller.replyMessage(message);
                    },
                  ),
                  _buildActionItem(
                    context: context,
                    icon: Icons.select_all,
                    label: '多选',
                    onTap: () {
                      Get.back();
                      controller.startMultiSelect(message);
                    },
                  ),
                  if (isTextMessage) ...[
                    _buildActionItem(
                      context: context,
                      icon: Icons.edit,
                      label: '编辑',
                      onTap: () {
                        Get.back();
                        // TODO: 实现编辑功能
                      },
                    ),
                  ],
                  if (isSentByMe) ...[
                    _buildActionItem(
                      context: context,
                      icon: Icons.delete_outline,
                      label: '删除',
                      onTap: () {
                        Get.back();
                        controller.deleteMessage(message);
                      },
                    ),
                  ],
                  if (isTextMessage) ...[
                    _buildActionItem(
                      context: context,
                      icon: Icons.font_download,
                      label: '朗读',
                      onTap: () {
                        Get.back();
                        controller.readMessage(message);
                      },
                    ),
                  ],
                  _buildActionItem(
                    context: context,
                    icon: Icons.info_outline,
                    label: '更多',
                    onTap: () {
                      Get.back();
                      // TODO: 显示更多选项
                    },
                  ),
                ],
              ),

              // 取消按钮
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    backgroundColor: theme.colorScheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '取消',
                    style: TextStyle(
                      fontSize: 17,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
