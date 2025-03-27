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
        await chatRef.set({
          'senderUID': currentUserUID,
          'receiverUID': receiverUID,
          'lastMessage': '',
          'timestamp': DateTime.now().toIso8601String(),
          'unreadCount': 0,
          'seen': false,
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating or retrieving chat room: $e');
      }
    }
    return chatRoomId;
  }

  static Future<void> incrementUnreadCount(
    String chatRoomId,
    String senderUid,
    String receiverUid,
  ) async {
    if (senderUid == receiverUid) return;

    DatabaseReference chatRef = database.ref('chats').child(chatRoomId);

    DatabaseEvent snapshot = await chatRef.once();
    if (snapshot.snapshot.exists) {
      Map<dynamic, dynamic> chatData = snapshot.snapshot.value as Map;

      int unreadCount = (chatData['unreadCount'] ?? 0) + 1;

      await chatRef.update({
        'unreadCount': unreadCount,
        'seen': false,
        'lastSenderUID': senderUid,
      });
    }
  }

  static Future<void> resetUnreadCount(
    String chatRoomId,
    String currentUserUid,
    String receiverUid,
  ) async {
    DatabaseReference chatRef = database.ref('chats').child(chatRoomId);
    await chatRef.update({'unreadCount': 0, 'seen': true});
  }
}
