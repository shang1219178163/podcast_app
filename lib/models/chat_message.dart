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
  final String? content;
  final String? senderId;
  final String? senderName;
  final String? senderAvatar;
  final DateTime? timestamp;
  final MessageType? type;
  final bool? isRead;
  final ChatMessage? replyTo;
  final Map<String, dynamic>? extra;

  const ChatMessage({
    required this.id,
    this.content,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.timestamp,
    this.type,
    this.isRead,
    this.replyTo,
    this.extra,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String?,
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      senderAvatar: json['senderAvatar'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
      type: json['type'] != null
          ? MessageType.values.firstWhere(
              (e) => e.toString() == 'MessageType.${json['type']}',
              orElse: () => MessageType.text,
            )
          : null,
      isRead: json['isRead'] as bool?,
      replyTo: json['replyTo'] != null ? ChatMessage.fromJson(json['replyTo'] as Map<String, dynamic>) : null,
      extra: json['extra'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (content != null) 'content': content,
      if (senderId != null) 'senderId': senderId,
      if (senderName != null) 'senderName': senderName,
      if (senderAvatar != null) 'senderAvatar': senderAvatar,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      if (type != null) 'type': type.toString().split('.').last,
      if (isRead != null) 'isRead': isRead,
      if (replyTo != null) 'replyTo': replyTo!.toJson(),
      if (extra != null) 'extra': extra,
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
