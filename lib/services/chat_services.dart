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

  static Future<void> blockUser(
    String chatRoomId,
    String blockedUserId,
  ) async {
    try {
      final String currentUserUID = auth.currentUser!.uid;
      final chatRef = database.ref().child('chats').child(chatRoomId);
      
      // Add blocked user to the blockedUsers map
      await chatRef.child('blockedUsers').child(currentUserUID).set({
        'blockedUserId': blockedUserId,
        'blockedAt': ServerValue.timestamp,
      });

      if (kDebugMode) {
        print('User $blockedUserId blocked successfully in chat $chatRoomId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error blocking user: $e');
      }
      rethrow;
    }
  }

  /// Unblock a user in a specific chat room
  static Future<void> unblockUser(
    String chatRoomId,
    String blockedUserId,
  ) async {
    try {
      final String currentUserUID = auth.currentUser!.uid;
      final chatRef = database.ref().child('chats').child(chatRoomId);
      
      // Remove blocked user from the blockedUsers map
      await chatRef.child('blockedUsers').child(currentUserUID).remove();

      if (kDebugMode) {
        print('User $blockedUserId unblocked successfully in chat $chatRoomId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unblocking user: $e');
      }
      rethrow;
    }
  }

  /// Check if current user has blocked another user in a chat room
  static Future<bool> isUserBlocked(
    String chatRoomId,
    String otherUserId,
  ) async {
    try {
      final String currentUserUID = auth.currentUser!.uid;
      final chatRef = database.ref().child('chats').child(chatRoomId);
      
      final snapshot = await chatRef
          .child('blockedUsers')
          .child(currentUserUID)
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map?;
        return data?['blockedUserId'] == otherUserId;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking block status: $e');
      }
      return false;
    }
  }

  /// Stream to listen for block status changes
  static Stream<bool> watchBlockStatus(
    String chatRoomId,
    String otherUserId,
  ) {
    final String currentUserUID = auth.currentUser!.uid;
    final chatRef = database.ref().child('chats').child(chatRoomId);
    
    return chatRef
        .child('blockedUsers')
        .child(currentUserUID)
        .onValue
        .map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map?;
        return data?['blockedUserId'] == otherUserId;
      }
      return false;
    });
  }

  /// Check if current user is blocked by another user
  static Future<bool> isBlockedByOtherUser(
    String chatRoomId,
    String otherUserId,
  ) async {
    try {
      final chatRef = database.ref().child('chats').child(chatRoomId);
      
      final snapshot = await chatRef
          .child('blockedUsers')
          .child(otherUserId)
          .get();

      if (snapshot.exists) {
        final String currentUserUID = auth.currentUser!.uid;
        final data = snapshot.value as Map?;
        return data?['blockedUserId'] == currentUserUID;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking if blocked by other user: $e');
      }
      return false;
    }
  }
}
