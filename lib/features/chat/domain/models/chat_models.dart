

enum MessageType { text, image, file }

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final String? attachmentUrl;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.attachmentUrl,
  });
}

class Conversation {
  final int id;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final int unreadCount;
  final bool isOnline;

  Conversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}
