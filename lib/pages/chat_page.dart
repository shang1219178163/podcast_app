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
        backgroundColor: const Color(0xFF2C2C2C),
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
                        onTapAvatar: message.senderId != null ? () => controller.onTapAvatar(message.senderId!) : null,
                        onLongPress: () => _showMessageActions(context, message),
                        onTapMessage: () => controller.onTapMessage(message),
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
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('复制'),
            onTap: () {
              Get.back();
              controller.copyMessage(message);
            },
          ),
          ListTile(
            leading: const Icon(Icons.reply),
            title: const Text('回复'),
            onTap: () {
              Get.back();
              controller.replyMessage(message);
            },
          ),
          if (isSentByMe)
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('删除'),
              onTap: () {
                Get.back();
                controller.deleteMessage(message);
              },
            ),
          ListTile(
            leading: const Icon(Icons.select_all),
            title: const Text('多选'),
            onTap: () {
              Get.back();
              controller.startMultiSelect(message);
            },
          ),
          if (message.type == MessageType.text && message.content != null)
            ListTile(
              leading: const Icon(Icons.font_download),
              title: const Text('文本朗读'),
              onTap: () {
                Get.back();
                controller.readMessage(message);
              },
            ),
        ],
      ),
    );
  }
}
