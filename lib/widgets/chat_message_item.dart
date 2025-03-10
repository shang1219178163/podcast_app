import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/network_image_widget.dart';
import 'message_action_menu/index.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;
  final String debugInfo;
  final VoidCallback? onTapAvatar;
  final VoidCallback? onLongPress;
  final VoidCallback? onTapMessage;
  final Function(ChatMessage)? onCopy;
  final Function(ChatMessage)? onForward;
  final Function(ChatMessage)? onReply;
  final Function(ChatMessage)? onMultiSelect;
  final Function(ChatMessage)? onEdit;
  final Function(ChatMessage)? onDelete;
  final Function(ChatMessage)? onRead;
  final Function(ChatMessage)? onMore;

  const ChatMessageItem({
    super.key,
    required this.message,
    this.debugInfo = "",
    this.onTapAvatar,
    this.onLongPress,
    this.onTapMessage,
    this.onCopy,
    this.onForward,
    this.onReply,
    this.onMultiSelect,
    this.onEdit,
    this.onDelete,
    this.onRead,
    this.onMore,
  });

  void _showMessageMenu(BuildContext context, TapDownDetails details) {
    final isSentByMe = message.senderId?.isNotEmpty != true;

    MessageActionMenu.show(
      context: context,
      message: message,
      position: details.globalPosition,
      isSentByMe: isSentByMe,
      onCopy: () => onCopy?.call(message),
      onForward: () => onForward?.call(message),
      onReply: () => onReply?.call(message),
      onMultiSelect: () => onMultiSelect?.call(message),
      onEdit: () => onEdit?.call(message),
      onDelete: () => onDelete?.call(message),
      onRead: () => onRead?.call(message),
      onMore: () => onMore?.call(message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSentByMe = message.senderId?.isNotEmpty != true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSentByMe) ...[
            // 接收消息的头像（左侧）
            GestureDetector(
              onTap: onTapAvatar,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: NetworkImageWidget(
                  url: message.senderAvatar ?? 'https://via.placeholder.com/40',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // 消息内容
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            child: Column(
              crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isSentByMe && message.senderName != null) ...[
                  Text(
                    message.senderName!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                GestureDetector(
                  onTapDown: (details) => _showMessageMenu(context, details),
                  onLongPress: onLongPress,
                  onTap: onTapMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSentByMe ? const Color(0xFF95EC69) : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _buildMessageBody(),
                  ),
                ),
                // 调试信息
                if (debugInfo.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      debugInfo,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.blue,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          if (isSentByMe) ...[
            // 发送消息的头像（右侧）
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onTapAvatar,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: NetworkImageWidget(
                  url: message.senderAvatar ?? 'https://via.placeholder.com/40',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (message.content == null) {
      return const Text('消息内容为空');
    }
    return _buildMessageBody();
  }

  Widget _buildMessageBody() {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content!,
          style: const TextStyle(fontSize: 16),
        );
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: NetworkImageWidget(
            url: message.content!,
            width: 150,
            height: 200,
            fit: BoxFit.cover,
            errorWidget: Container(
              width: 150,
              height: 200,
              color: Colors.grey[200],
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),
        );
      case MessageType.voice:
        final duration = message.extra?['duration'] as int? ?? 0;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow),
            const SizedBox(width: 4),
            Text('${duration}s'),
          ],
        );
      case MessageType.emoji:
        return Text(
          message.content!,
          style: const TextStyle(fontSize: 24),
        );
      case null:
        return const Text('未知消息类型');
      default:
        return const Text('不支持的消息类型');
    }
  }
}
