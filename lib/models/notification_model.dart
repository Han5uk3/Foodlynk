class NotificationModel {
  final String? body;
  final String? notificationId;
  final int? timestamp;
  final String? title;
  final String? type;
  final String? uid;

  NotificationModel({
    this.body,
    this.notificationId,
    this.timestamp,
    this.title,
    this.type,
    this.uid,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      body: map['body'] as String?,
      notificationId: map['notificationId'] as String?,
      timestamp: map['timestamp'] as int?,
      title: map['title'] as String?,
      type: map['type'] as String?,
      uid: map['uid'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'notificationId': notificationId,
      'timestamp': timestamp,
      'title': title,
      'type': type,
      'uid': uid,
    };
  }

  @override
  String toString() {
    return 'NotificationModel(body: $body, notificationId: $notificationId, timestamp: $timestamp, title: $title, type: $type, uid: $uid)';
  }
}
