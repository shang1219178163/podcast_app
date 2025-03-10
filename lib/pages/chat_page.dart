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
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        // backgroundColor: const Color(0xFF2C2C2C),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.chatTitle,
              style: const TextStyle(fontSize: 17),
            ),
            if (controller.isTyping.value)
              const Text(
                '对方正在输入...',
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
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
                        onCopy: controller.copyMessage,
                        onForward: (message) => controller.startMultiSelect(message),
                        onReply: controller.replyMessage,
                        onMultiSelect: controller.startMultiSelect,
                        onEdit: (message) {
                          // TODO: 实现编辑功能
                        },
                        onDelete: controller.deleteMessage,
                        onRead: controller.readMessage,
                        onMore: (message) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _formatTime(time),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
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
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('添加成员'),
            onTap: () {
              Get.back();
              controller.addMember();
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('搜索聊天记录'),
            onTap: () {
              Get.back();
              controller.searchMessages();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('清空聊天记录'),
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
    final isSentByMe = message.senderId == controller.currentUserId;
    final isTextMessage = message.type == MessageType.text;
    final isImageMessage = message.type == MessageType.image;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
                  color: Colors.grey[300],
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
                      icon: Icons.forward,
                      label: '转发',
                      onTap: () {
                        Get.back();
                        controller.startMultiSelect(message);
                      },
                    ),
                  ],
                  _buildActionItem(
                    icon: Icons.reply,
                    label: '引用',
                    onTap: () {
                      Get.back();
                      controller.replyMessage(message);
                    },
                  ),
                  _buildActionItem(
                    icon: Icons.select_all,
                    label: '多选',
                    onTap: () {
                      Get.back();
                      controller.startMultiSelect(message);
                    },
                  ),
                  if (isTextMessage) ...[
                    _buildActionItem(
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
                      icon: Icons.font_download,
                      label: '朗读',
                      onTap: () {
                        Get.back();
                        controller.readMessage(message);
                      },
                    ),
                  ],
                  _buildActionItem(
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
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '取消',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
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
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
