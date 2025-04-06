class ChatMessage {
  final String id;
  final String senderUID;
  final String message;
  final DateTime timestamp;
  final bool seen;

  ChatMessage({
    required this.id,
    required this.senderUID,
    required this.message,
    required this.timestamp,
    required this.seen,
  });

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map, String id) {
    return ChatMessage(
      id: id,
      senderUID: map['senderUID'] ?? map['senderId'] ?? '',
      message: map['message'] ?? map['text'] ?? '',
      timestamp: _parseTimestamp(map['timestamp']),
      seen: map['seen'] ?? false,
    );
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}
