class ChatMessage {
  final String id;
  final String senderUID;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderUID,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map, String id) {
    return ChatMessage(
      id: id,
      senderUID: map['senderUID'] ?? '',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] != ''
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }
}