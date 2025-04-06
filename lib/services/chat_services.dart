import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class ChatServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseDatabase database = FirebaseDatabase.instance;

  static Future<String?> getOrCreateChatRoom(String receiverUID) async {
    final String currentUserUID = auth.currentUser!.uid;
    List<String> ids = [currentUserUID, receiverUID]..sort();
    String chatRoomId = "${ids[0]}_${ids[1]}";
    DatabaseReference chatRef = database.ref().child('chats').child(chatRoomId);
    DataSnapshot snapshot = await chatRef.get();
    try {
      if (!snapshot.exists) {
        final now = ServerValue.timestamp;
        final Map<String, dynamic> chatData = {
          "participants": {currentUserUID: true, receiverUID: true},
          "lastMessage": {"text": "", "timestamp": now, "senderId": ""},
        };

        await chatRef.set(chatData);
        final userChatsRef = database.ref().child('userChats');
        for (String uid in ids) {
          await userChatsRef.child(uid).child(chatRoomId).set({
            "unreadCount": 0,
            "lastSeen": ServerValue.timestamp,
            "chatWith": uid == currentUserUID ? receiverUID : currentUserUID,
            "lastMessage": {"text": "", "timestamp": now, "senderId": ""},
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating or retrieving chat room: $e');
      }
    }
    return chatRoomId;
  }

  static Future<void> resetUnreadCount(
    String chatRoomId,
    String currentUserUid,
  ) async {
    final chatRef = database.ref('chats').child(chatRoomId);
    final messagesRef = chatRef.child('messages');
    final snapshot = await messagesRef.get();
    if (snapshot.exists) {
      final updates = <String, dynamic>{};
      for (final child in snapshot.children) {
        final msg = child.value as Map?;
        final senderUID = msg?['senderUID'];
        if (senderUID != currentUserUid && msg?['seen'] != true) {
          updates['${child.key}/seen'] = true;
        }
      }
      if (updates.isNotEmpty) {
        await messagesRef.update(updates);
      }
    }
    await chatRef.update({
      'seen_by/$currentUserUid': true,
      'unread_count/$currentUserUid': 0,
    });
  }
}
