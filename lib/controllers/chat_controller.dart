import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../utils/log_util.dart';

class ChatController extends GetxController {
  final String chatId;
  final String chatTitle;
  final String currentUserId;

  ChatController({
    required this.chatId,
    required this.chatTitle,
    required this.currentUserId,
  });

  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;
  final isRecording = false.obs;
  final isMultiSelecting = false.obs;
  final selectedMessages = <String>{}.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadMessages() async {
    try {
      // TODO: 从服务器加载消息
      LogUtil.d('加载聊天消息');
      // 模拟加载消息
      await Future.delayed(const Duration(seconds: 1));
      messages.value = List.generate(
        20,
        (index) => ChatMessage(
          id: 'msg_$index',
          content: '这是第 $index 条消息',
          senderId: index % 2 == 0 ? currentUserId : 'other_user',
          senderName: index % 2 == 0 ? '我' : '对方',
          senderAvatar: 'https://picsum.photos/200?random=$index',
          timestamp: DateTime.now().subtract(Duration(minutes: index * 5)),
          type: MessageType.text,
        ),
      );
    } catch (e) {
      LogUtil.e('加载消息失败: $e');
    }
  }

  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty) return;
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        senderId: currentUserId,
        senderName: '我',
        senderAvatar: 'https://picsum.photos/200',
        timestamp: DateTime.now(),
        type: MessageType.text,
      );
      messages.insert(0, message);
      // TODO: 发送消息到服务器
      LogUtil.d('发送文本消息: $text');
    } catch (e) {
      LogUtil.e('发送消息失败: $e');
    }
  }

  Future<void> sendVoiceMessage(String voicePath, int duration) async {
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: voicePath,
        senderId: currentUserId,
        senderName: '我',
        senderAvatar: 'https://picsum.photos/200',
        timestamp: DateTime.now(),
        type: MessageType.voice,
        extra: {'duration': duration},
      );
      messages.insert(0, message);
      // TODO: 上传语音文件到服务器
      LogUtil.d('发送语音消息: $voicePath, 时长: $duration');
    } catch (e) {
      LogUtil.e('发送语音消息失败: $e');
    }
  }

  Future<void> sendImageMessage(String imagePath) async {
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: imagePath,
        senderId: currentUserId,
        senderName: '我',
        senderAvatar: 'https://picsum.photos/200',
        timestamp: DateTime.now(),
        type: MessageType.image,
      );
      messages.insert(0, message);
      // TODO: 上传图片到服务器
      LogUtil.d('发送图片消息: $imagePath');
    } catch (e) {
      LogUtil.e('发送图片消息失败: $e');
    }
  }

  Future<void> sendEmojiMessage(String emoji) async {
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: emoji,
        senderId: currentUserId,
        senderName: '我',
        senderAvatar: 'https://picsum.photos/200',
        timestamp: DateTime.now(),
        type: MessageType.emoji,
      );
      messages.insert(0, message);
      // TODO: 发送消息到服务器
      LogUtil.d('发送表情消息: $emoji');
    } catch (e) {
      LogUtil.e('发送表情消息失败: $e');
    }
  }

  void onTapAvatar(String userId) {
    // TODO: 跳转到用户资料页
    LogUtil.d('点击头像: $userId');
  }

  void onTapMessage(ChatMessage message) {
    if (isMultiSelecting.value) {
      toggleMessageSelection(message.id);
      return;
    }

    switch (message.type) {
      case MessageType.image:
        // TODO: 查看大图
        LogUtil.d('查看图片: ${message.content}');
        break;
      case MessageType.voice:
        // TODO: 播放语音
        LogUtil.d('播放语音: ${message.content}');
        break;
      default:
        break;
    }
  }

  void copyMessage(ChatMessage message) {
    if (message.type != MessageType.text) return;
    Clipboard.setData(ClipboardData(text: message.content));
    Get.snackbar('提示', '已复制');
  }

  void replyMessage(ChatMessage message) {
    // TODO: 实现回复功能
    LogUtil.d('回复消息: ${message.content}');
  }

  void deleteMessage(ChatMessage message) {
    messages.removeWhere((m) => m.id == message.id);
    // TODO: 从服务器删除消息
    LogUtil.d('删除消息: ${message.id}');
  }

  void startMultiSelect(ChatMessage message) {
    isMultiSelecting.value = true;
    toggleMessageSelection(message.id);
  }

  void toggleMessageSelection(String messageId) {
    if (selectedMessages.contains(messageId)) {
      selectedMessages.remove(messageId);
    } else {
      selectedMessages.add(messageId);
    }

    if (selectedMessages.isEmpty) {
      isMultiSelecting.value = false;
    }
  }

  void cancelMultiSelect() {
    isMultiSelecting.value = false;
    selectedMessages.clear();
  }

  void forwardSelectedMessages() {
    // TODO: 实现转发功能
    LogUtil.d('转发选中的消息: $selectedMessages');
    cancelMultiSelect();
  }

  void deleteSelectedMessages() {
    messages.removeWhere((m) => selectedMessages.contains(m.id));
    // TODO: 从服务器删除消息
    LogUtil.d('删除选中的消息: $selectedMessages');
    cancelMultiSelect();
  }

  void addMember() {
    // TODO: 实现添加成员功能
    LogUtil.d('添加成员');
  }

  void searchMessages() {
    // TODO: 实现搜索功能
    LogUtil.d('搜索消息');
  }

  void clearMessages() {
    Get.dialog(
      AlertDialog(
        title: const Text('清空聊天记录'),
        content: const Text('确定要清空所有聊天记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              messages.clear();
              // TODO: 从服务器清空消息
              LogUtil.d('清空聊天记录');
              Get.back();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void readMessage(ChatMessage message) {
    // TODO: 实现文本朗读功能
    LogUtil.d('朗读消息: ${message.content}');
  }
}
