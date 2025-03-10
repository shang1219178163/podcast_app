import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onTapAvatar;
  final VoidCallback? onLongPress;
  final VoidCallback? onTapMessage;

  const ChatMessageItem({
    super.key,
    required this.message,
    this.onTapAvatar,
    this.onLongPress,
    this.onTapMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isSentByMe = message.senderId == 'currentUserId'; // TODO: 从控制器获取 currentUserId

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: isSentByMe ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // 头像
          GestureDetector(
            onTap: onTapAvatar,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                message.senderAvatar,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, color: Colors.grey),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 消息内容
          Expanded(
            child: Column(
              crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isSentByMe) ...[
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                GestureDetector(
                  onLongPress: onLongPress,
                  onTap: onTapMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSentByMe ? const Color(0xFF95EC69) : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _buildMessageContent(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 50), // 留出空间防止消息太靠边
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: const TextStyle(fontSize: 16),
        );
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            message.content,
            width: 150,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 150,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              );
            },
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
          message.content,
          style: const TextStyle(fontSize: 24),
        );
      default:
        return const Text('不支持的消息类型');
    }
  }
}
