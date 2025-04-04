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
        });
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
    DatabaseReference chatRef = database.ref('chats').child(chatRoomId);
    await chatRef.update({
      'seen_by/$currentUserUid': true,
      'unread_count/$currentUserUid': 0,
    });
  }

  static Future<void> resetUnreadCountForCurrentUser(
    String chatRoomId,
    String currentUID,
  ) async {
    final chatRef = database.ref('chats').child(chatRoomId);

    await chatRef.update({
      'unreadCount_$currentUID': 0,
      'seen_$currentUID': true,
    });
  }
}
