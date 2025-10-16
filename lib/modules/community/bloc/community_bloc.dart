import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/api/app_apis.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/models/chat_model.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/services/chat_services.dart';
part 'community_event.dart';
part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final DatabaseReference dbRef = ChatServices.database.ref('chats');
  StreamSubscription? _chatRoomsSubscription;
  CommunityBloc() : super(const CommunityState()) {
    on<LoadChatRoomsEvent>(_onLoadChatRooms);
    on<FetchUserDetailsEvent>(_onFetchUserDetails);
    on<InitializeChatRoomEvent>(_onInitializeChatRoom);
    on<SendMessageEvent>(_onSendMessage);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<UpdateMessagesEvent>(_onUpdateMessages);
    on<ReportUserEvent>(_onReportUserEvent);
    on<ClearCommunityStateEvent>(_onClearCommunityStateEvent);
    on<BlockUserEvent>(_onBlockUser);
    on<UnblockUserEvent>(_onUnblockUser);
    on<CheckBlockStatusEvent>(_onCheckBlockStatus);
    add(LoadChatRoomsEvent());
  }

  Future<void> _onLoadChatRooms(
    LoadChatRoomsEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ChatStatus.loading,
        userDetails: {},
        chatRooms: [],
      ),
    );

    try {
      await _chatRoomsSubscription?.cancel();

      _chatRoomsSubscription =
          ChatServices.database.ref('chats').onValue.listen(
        (snapshot) {
          if (snapshot.snapshot.value != null) {
            Map<dynamic, dynamic> chatRooms =
                snapshot.snapshot.value as Map<dynamic, dynamic>;

            List<Map<String, dynamic>> rooms = [];
            List<String> receiverUIDs = [];

            try {
              chatRooms.forEach((key, value) {
                if (value is Map) {
                  List<String> uids = key.split('_');
                  if (uids.length == 2) {
                    String senderUID = uids[0];
                    String receiverUID = uids[1];

                    if (uids.contains(Services.uid)) {
                      String otherUserUID =
                          (Services.uid == senderUID) ? receiverUID : senderUID;

                      int unreadCount = 0;
                      var unreadRaw = value['unread_count'];
                      if (unreadRaw is Map && unreadRaw[Services.uid] != null) {
                        unreadCount = unreadRaw[Services.uid];
                      }

                      bool isSeen = false;
                      var seenRaw = value['seen_by'];
                      if (seenRaw is Map && seenRaw[Services.uid] != null) {
                        isSeen = seenRaw[Services.uid];
                      }

                      String lastMessageText =
                          value['lastMessage']?.toString() ?? '';

                      int lastTimestamp = 0;
                      try {
                        String timestampStr = value['timestamp'] ?? '';
                        if (timestampStr.isNotEmpty) {
                          lastTimestamp = DateTime.parse(
                            timestampStr,
                          ).millisecondsSinceEpoch;
                        }
                      } catch (e) {
                        debugPrint('Timestamp parse error: $e');
                      }

                      rooms.add({
                        'roomId': key,
                        'receiverUID': otherUserUID,
                        'lastMessage': {
                          'text': lastMessageText,
                          'timestamp': lastTimestamp,
                        },
                        'timestamp': lastTimestamp,
                        'unreadCount': unreadCount,
                        'isSeen': isSeen,
                        'lastSenderUID': value['lastSenderUID'] ?? '',
                      });

                      receiverUIDs.add(otherUserUID);
                    }
                  }
                }
              });
            } catch (e) {
              debugPrint("ERROR: Error parsing chatRooms: $e");
            }
            rooms.sort(
              (a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0),
            );
            _fetchUserDetails(receiverUIDs).then((userDetails) {
              add(FetchUserDetailsEvent(rooms, userDetails));
            });
          } else {
            add(FetchUserDetailsEvent([], {}));
          }
        },
        onError: (error) {
          emit(
            state.copyWith(
              status: ChatStatus.error,
              errorMessage: error.toString(),
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: ChatStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onFetchUserDetails(
    FetchUserDetailsEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ChatStatus.loaded,
        chatRooms: event.rooms,
        userDetails: event.userDetails,
      ),
    );
  }

  Future<void> _onInitializeChatRoom(
    InitializeChatRoomEvent event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ChatStatus.loading));
      String? chatRoomId;
      String currentUID = Services.uid ?? '';

      if (event.receiverUid != null) {
        chatRoomId = await ChatServices.getOrCreateChatRoom(
          event.receiverUid ?? "",
        );
      } else if (event.roomId != null) {
        chatRoomId = event.roomId;
      }

      if (chatRoomId != null) {
        // Extract receiver UID from chat room ID if not provided
        final String receiverUid = event.receiverUid ??
            (() {
              List<String> chatRoomParts = chatRoomId!.split('_');
              if (chatRoomParts.length == 2) {
                return chatRoomParts[0] == Services.uid
                    ? chatRoomParts[1]
                    : chatRoomParts[0];
              }
              return "";
            })();

        // ✅ CHECK BLOCK STATUS IMMEDIATELY
        final isBlocked = await ChatServices.isUserBlocked(
          chatRoomId,
          receiverUid,
        );

        emit(
          state.copyWith(
            currentChatRoomId: chatRoomId,
            currentReceiverUid: receiverUid,
            status: ChatStatus.goToChatPage,
            isBlockedByMe: isBlocked, // ✅ Set block status immediately
            blockedUserId: isBlocked ? receiverUid : null,
          ),
        );

        if (event.isFoodSwapped ||
            event.isFromDonations ||
            event.isFromBeneficiary) {
          await _sendInitialFoodSwapMessages(
            chatRoomId,
            currentUID,
            event.receiverUid ?? "",
            event.fcmToken ?? '',
            event.isFoodSwapped,
            event.isFromDonations,
            event.isFromBeneficiary,
            event.localizedMessages!,
          );
        }

        Future.delayed(
          const Duration(milliseconds: 500),
        ).then((value) => add(LoadMessagesEvent()));
      } else {
        emit(
          state.copyWith(
            status: ChatStatus.error,
            errorMessage: 'Failed to find or create chat room',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: ChatStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<CommunityState> emit,
  ) async {
    if (state.currentChatRoomId == null || event.message.trim().isEmpty) return;

    try {
      emit(state.copyWith(status: ChatStatus.sending));

      final timestamp = DateTime.now().toIso8601String();
      final chatRoomId = state.currentChatRoomId!;
      final message = event.message.trim();

      final messageRef = ChatServices.database
          .ref('chats')
          .child(chatRoomId)
          .child('messages')
          .push();

      await messageRef.set({
        'senderUID': Services.uid,
        'message': message,
        'timestamp': timestamp,
        'seen': false,
      });

      final updates = {
        'lastMessage': message,
        'lastSenderUID': Services.uid,
        'timestamp': timestamp,
        'seen_by/${Services.uid}': true,
        'seen_by/${event.reciversUid}': false,
        'unread_count/${Services.uid}': 0,
        'participants/${Services.uid}': true,
        'participants/${event.reciversUid}': true,
      };

      if (Services.uid != event.reciversUid) {
        updates['unread_count/${event.reciversUid}'] = ServerValue.increment(1);
      }

      await ChatServices.database
          .ref('chats')
          .child(chatRoomId)
          .update(updates);

      if (event.fcmToken != null && event.fcmToken!.isNotEmpty) {
        await AppApis().sendNotificationToFCM(
          title: event.reciversName,
          subTitle: message,
          token: event.fcmToken!,
          chatRoomId: chatRoomId,
          type: 'message',
          reciversUid: event.reciversUid,
        );
      }

      emit(state.copyWith(status: ChatStatus.loaded));
    } catch (e) {
      debugPrint('Error sending message: $e');
      emit(
        state.copyWith(
          status: ChatStatus.error,
          errorMessage: 'Failed to send message: ${e.toString()}',
        ),
      );
    }
  }

  StreamSubscription? _messagesSubscription;
  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));

    if (state.currentChatRoomId == null) return;

    _messagesSubscription?.cancel();

    // Extract receiver UID from chat room ID
    String? receiverUid;
    if (state.currentChatRoomId != null) {
      List<String> chatRoomParts = state.currentChatRoomId!.split('_');
      if (chatRoomParts.length == 2) {
        receiverUid = chatRoomParts[0] == Services.uid
            ? chatRoomParts[1]
            : chatRoomParts[0];
        if (receiverUid != state.currentReceiverUid) {
          // Update the current receiver UID if it has changed
          emit(state.copyWith(currentReceiverUid: receiverUid));
        }
      }
    }

    final chatRef = ChatServices.database
        .ref('chats')
        .child(state.currentChatRoomId!)
        .child('messages');
    log("Loading messages for user: ${state.currentReceiverUid ?? receiverUid ?? "unknown"}");

    _messagesSubscription = chatRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final messagesMap = event.snapshot.value as Map<dynamic, dynamic>;

        final messages = messagesMap.entries
            .where(
          (entry) =>
              entry.value is Map &&
                  (entry.value as Map).containsKey('message') ||
              (entry.value as Map).containsKey('text'),
        )
            .map((entry) {
          return ChatMessage.fromMap(entry.value, entry.key);
        }).toList();

        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        add(UpdateMessagesEvent(messages));
      }
    });
  }

  void _onUpdateMessages(
    UpdateMessagesEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(state.copyWith(messages: event.messages, status: ChatStatus.loaded));

    // Make sure we have the current receiver's details loaded
    if (state.currentReceiverUid != null &&
        (!state.userDetails.containsKey(state.currentReceiverUid) ||
            state.userDetails[state.currentReceiverUid]!.isEmpty)) {
      // Fetch the user details if we don't have them
      Map<String, Map<String, dynamic>> userDetails =
          await _fetchUserDetails([state.currentReceiverUid!]);
      if (userDetails.isNotEmpty) {
        emit(state
            .copyWith(userDetails: {...state.userDetails, ...userDetails}));
      }
    }

    if (state.currentChatRoomId != null) {
      await ChatServices.resetUnreadCount(
        state.currentChatRoomId!,
        Services.uid ?? "",
      );
    }
  }

  void _onClearCommunityStateEvent(
    ClearCommunityStateEvent event,
    Emitter<CommunityState> emit,
  ) async {
    await _chatRoomsSubscription?.cancel();
    await _messagesSubscription?.cancel();

    emit(const CommunityState(
      chatRooms: [],
      userDetails: {},
      currentChatRoomId: null,
      currentReceiverUid: null,
      messages: [],
      status: ChatStatus.initial,
      errorMessage: null,
      isBlockedByMe: false,
      isBlockedByOther: false,
      blockedUserId: null,
    ));
  }

  void _onReportUserEvent(
    ReportUserEvent event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      await Collections.reports.add({
        'reporterUID': Services.uid,
        'reportedUID': event.reportedUID,
        'reason': event.reportReason,
        'timestamp': DateTime.now().toIso8601String(),
      });
      emit(state.copyWith(status: ChatStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(status: ChatStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<Map<String, Map<String, dynamic>>> _fetchUserDetails(
    List<String> uids,
  ) async {
    Map<String, Map<String, dynamic>> userDetails = {};
    if (uids.isNotEmpty) {
      var query = await Collections.users.where('uid', whereIn: uids).get();
      for (var doc in query.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        String uid = userData['uid'];
        userDetails[uid] = userData;
      }
    }
    return userDetails;
  }

  @override
  Future<void> close() {
    _chatRoomsSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }

  Future<void> _sendInitialFoodSwapMessages(
    String chatRoomId,
    String currentUID,
    String receiverUID,
    String token,
    bool isFoodSwap,
    bool isDonation,
    bool isBeneficiary,
    Map<String, String> localizedMessages,
  ) async {
    final now = DateTime.now();
    final nowIso = now.toIso8601String();
    final timestamp = now.millisecondsSinceEpoch;
    List<Map<String, dynamic>> initialMessages = isFoodSwap
        ? [
            {
              'senderId': currentUID,
              'text': '${localizedMessages['hello']} 👋',
              'timestamp': timestamp,
            },
            {
              'senderId': currentUID,
              'text': '${localizedMessages['acceptFoodSwap']} 🍲',
              'timestamp': timestamp,
            },
          ]
        : isDonation
            ? [
                {
                  'senderId': currentUID,
                  'text': '${localizedMessages['hello']} 👋',
                  'timestamp': timestamp,
                },
                {
                  'senderId': currentUID,
                  'text': '${localizedMessages['donateFoodMessage']} 🍲',
                  'timestamp': timestamp,
                },
              ]
            : isBeneficiary
                ? [
                    {
                      'senderId': currentUID,
                      'text': '${localizedMessages['hello']} 👋',
                      'timestamp': timestamp,
                    },
                    {
                      'senderId': currentUID,
                      'text': '${localizedMessages['receiveFoodMessage']} 🍲',
                      'timestamp': timestamp,
                    },
                  ]
                : [];

    final chatMessagesRef = ChatServices.database.ref(
      'chats/$chatRoomId/messages',
    );
    for (var msg in initialMessages) {
      await chatMessagesRef.push().set(msg);
    }

    final lastMsg = initialMessages.last;

    await ChatServices.database.ref('chats/$chatRoomId').update({
      'lastMessage': lastMsg['text'],
      'lastSenderUID': currentUID,
      'timestamp': nowIso,
      'seen_by': {currentUID: true, receiverUID: false},
    });

    await ChatServices.database
        .ref('userChats/$currentUID/$chatRoomId')
        .update({
      'unreadCount': 0,
      'lastSeen': timestamp,
      'chatWith': receiverUID,
      'lastMessage': lastMsg['text'],
    });

    await ChatServices.database
        .ref('userChats/$receiverUID/$chatRoomId')
        .update({
      'unreadCount': initialMessages.length,
      'lastSeen': null,
      'chatWith': currentUID,
      'lastMessage': lastMsg['text'],
    });

    if (token.isNotEmpty) {
      await AppApis().sendNotificationToFCM(
        title: isFoodSwap
            ? localizedMessages['foodSwapAccepted'] ?? 'Food Swap Accepted'
            : isDonation
                ? localizedMessages['foodSwapAccepted'] ?? 'Food Swap Accepted'
                : isBeneficiary
                    ? localizedMessages['beneficiaryAccepted'] ??
                        'Beneficiary Accepted'
                    : "",
        subTitle: lastMsg['text'],
        token: token,
        chatRoomId: chatRoomId,
        type: 'message',
        reciversUid: receiverUID,
      );
    }
  }

  Future<void> _onBlockUser(
    BlockUserEvent event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      await ChatServices.blockUser(event.chatRoomId, event.blockedUserId);

      emit(state.copyWith(
        isBlockedByMe: true,
        blockedUserId: event.blockedUserId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'Failed to block user: ${e.toString()}',
      ));
    }
  }

  Future<void> _onUnblockUser(
    UnblockUserEvent event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      await ChatServices.unblockUser(event.chatRoomId, event.blockedUserId);

      emit(state.copyWith(
        isBlockedByMe: false,
        blockedUserId: null, // This will now properly set to null
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'Failed to unblock user: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCheckBlockStatus(
    CheckBlockStatusEvent event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      final isBlocked = await ChatServices.isUserBlocked(
        event.chatRoomId,
        event.otherUserId,
      );

      emit(state.copyWith(
        isBlockedByMe: isBlocked,
        blockedUserId: isBlocked ? event.otherUserId : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'Failed to check block status: ${e.toString()}',
      ));
    }
  }
}
