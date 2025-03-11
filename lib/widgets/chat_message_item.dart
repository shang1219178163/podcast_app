import 'package:flutter/material.dart';
import 'package:podcast_app/widgets/floating_menu.dart';
import '../models/chat_message.dart';
import '../widgets/network_image_widget.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;
  final String debugInfo;
  final VoidCallback? onTapAvatar;
  final VoidCallback? onLongPress;
  final VoidCallback? onTapMessage;
  final VoidCallback? onCopy;
  final VoidCallback? onForward;
  final VoidCallback? onReply;
  final VoidCallback? onMultiSelect;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRead;
  final VoidCallback? onMore;

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

  void hide() {
    FloatingMenu.hide();
  }

  void _showMessageMenu(BuildContext context, TapDownDetails details) {
    final isSentByMe = message.senderId?.isNotEmpty != true;

    final isTextMessage = message.type == MessageType.text;
    final isImageMessage = message.type == MessageType.image;

    // 构建菜单项
    final items = <FloatingMenuItem>[];
    if (isTextMessage && onCopy != null) {
      items.add(FloatingMenuItem(
        icon: Icons.copy,
        label: '复制',
        onTap: () {
          hide();
          onCopy?.call();
        },
      ));
    }

    if (isTextMessage || isImageMessage && onForward != null) {
      items.add(FloatingMenuItem(
        icon: Icons.forward,
        label: '转发',
        onTap: () {
          hide();
          onForward?.call();
        },
      ));
    }

    if (onReply != null) {
      items.add(FloatingMenuItem(
        icon: Icons.reply,
        label: '引用',
        onTap: () {
          hide();
          onReply?.call();
        },
      ));
    }

    if (onMultiSelect != null) {
      FloatingMenuItem(
        icon: Icons.select_all,
        label: '多选',
        onTap: () {
          hide();
          onMultiSelect?.call();
        },
      );
    }

    if (isTextMessage && onEdit != null) {
      items.add(FloatingMenuItem(
        icon: Icons.edit,
        label: '编辑',
        onTap: () {
          hide();
          onEdit?.call();
        },
      ));
    }

    if (isSentByMe && onDelete != null) {
      items.add(FloatingMenuItem(
        icon: Icons.delete_outline,
        label: '删除',
        onTap: () {
          hide();
          onDelete?.call();
        },
      ));
    }

    if (isTextMessage && onRead != null) {
      items.add(FloatingMenuItem(
        icon: Icons.font_download,
        label: '朗读',
        onTap: () {
          hide();
          onRead?.call();
        },
      ));
    }

    if (onMore != null) {
      items.add(FloatingMenuItem(
        icon: Icons.info_outline,
        label: '更多',
        onTap: () {
          hide();
          onMore?.call();
        },
      ));
    }
    // 显示菜单
    FloatingMenu.show(
      context: context,
      position: details.globalPosition,
      items: items,
    );
  }

}
