import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/network_image_widget.dart';

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
