enum MessageType {
  text,
  image,
  voice,
  video,
  file,
  location,
  emoji,
}

class ChatMessage {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;
  final ChatMessage? replyTo;
  final Map<String, dynamic>? extra;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.replyTo,
    this.extra,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
      ),
      isRead: json['isRead'] as bool? ?? false,
      replyTo: json['replyTo'] != null ? ChatMessage.fromJson(json['replyTo'] as Map<String, dynamic>) : null,
      extra: json['extra'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'isRead': isRead,
      'replyTo': replyTo?.toJson(),
      'extra': extra,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    DateTime? timestamp,
    MessageType? type,
    bool? isRead,
    ChatMessage? replyTo,
    Map<String, dynamic>? extra,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      replyTo: replyTo ?? this.replyTo,
      extra: extra ?? this.extra,
    );
  }
}
