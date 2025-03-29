import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
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
    add(LoadChatRoomsEvent());
  }

  Future<void> _onLoadChatRooms(
    LoadChatRoomsEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));

    try {
      await _chatRoomsSubscription?.cancel();

      _chatRoomsSubscription = ChatServices.database
          .ref('chats')
          .onValue
          .listen(
            (snapshot) async {
              if (snapshot.snapshot.value != null) {
                Map<dynamic, dynamic> chatRooms =
                    snapshot.snapshot.value as Map<dynamic, dynamic>;

                List<Map<String, dynamic>> rooms = [];
                List<String> receiverUIDs = [];

                chatRooms.forEach((key, value) {
                  if (value is Map) {
                    List<String> uids = key.split('_');
                    if (uids.length == 2) {
                      String senderUID = uids[0];
                      String receiverUID = uids[1];

                      if (uids.contains(Services.uid)) {
                        String otherUserUID =
                            (Services.uid == senderUID)
                                ? receiverUID
                                : senderUID;

                        rooms.add({
                          'roomId': key,
                          'receiverUID': otherUserUID,
                          'lastMessage': value['lastMessage'] ?? '',
                          'timestamp': value['timestamp'] ?? '',
                          'unreadCount': value['unreadCount'] ?? 0,
                          'lastSenderUID': value['lastSenderUID'] ?? '',
                          'seen': value['seen'] ?? false,
                        });

                        receiverUIDs.add(otherUserUID);
                      }
                    }
                  }
                });

                rooms.sort(
                  (a, b) =>
                      (b['timestamp'] ?? '').compareTo(a['timestamp'] ?? ''),
                );

                Map<String, Map<String, dynamic>> userDetails = {};
                try {
                  if (receiverUIDs.isNotEmpty) {
                    var query =
                        await Collections.users
                            .where('uid', whereIn: receiverUIDs)
                            .get();

                    for (var doc in query.docs) {
                      Map<String, dynamic> userData =
                          doc.data() as Map<String, dynamic>;
                      String uid = userData['uid'];
                      userDetails[uid] = userData;
                    }
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print('Error fetching user details: $e');
                  }
                }

                add(FetchUserDetailsEvent(rooms, userDetails));
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
      String currentUID = Services.uid;
      if (event.receiverUid != null) {
        chatRoomId = await ChatServices.getOrCreateChatRoom(
          event.receiverUid ?? "",
        );
      } else if (event.roomId != null) {
        chatRoomId = event.roomId;
      }

      if (chatRoomId != null) {
        await ChatServices.resetUnreadCount(
          chatRoomId,
          currentUID,
          event.receiverUid ?? "",
        );

        emit(
          state.copyWith(
            currentChatRoomId: chatRoomId,
            status: ChatStatus.goToChatPage,
          ),
        );
        if (event.isFoodSwapped) {
          await _sendInitialFoodSwapMessages(chatRoomId, currentUID);
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
      final messageRef =
          ChatServices.database
              .ref('chats')
              .child(state.currentChatRoomId!)
              .child('messages')
              .push();

      await messageRef.set({
        'senderUID': Services.uid,
        'message': event.message.trim(),
        'timestamp': timestamp,
      });
      await AppApis().sendNotificationToFCM(
        title: event.reciversName,
        subTitle: event.message.trim(),
        token: event.fcmToken,
        chatRoomId: state.currentChatRoomId,
        type: 'message',
        reciversUid: event.reciversUid,
      );
      await ChatServices.database
          .ref('chats')
          .child(state.currentChatRoomId!)
          .update({
            'lastMessage': event.message.trim(),
            'timestamp': timestamp,
          });

      await ChatServices.incrementUnreadCount(
        state.currentChatRoomId!,
        Services.uid,
        state.currentReceiverUid ?? "",
      );

      emit(state.copyWith(status: ChatStatus.loaded));
    } catch (e) {
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
    final chatRef = ChatServices.database
        .ref('chats')
        .child(state.currentChatRoomId!)
        .child('messages');

    _messagesSubscription = chatRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final messagesMap = event.snapshot.value as Map<dynamic, dynamic>;
        final messages =
            messagesMap.entries.map((entry) {
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
  ) {
    emit(state.copyWith(messages: event.messages, status: ChatStatus.loaded));
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
  ) async {
    final timestamp = DateTime.now().toIso8601String();

    List<Map<String, dynamic>> initialMessages = [
      {'senderUID': currentUID, 'message': 'Hello 👋', 'timestamp': timestamp},
      {
        'senderUID': currentUID,
        'message': 'I accept your food swap! 🍲',
        'timestamp': timestamp,
      },
    ];

    for (var msg in initialMessages) {
      final messageRef =
          ChatServices.database.ref('chats/$chatRoomId/messages').push();

      await messageRef.set(msg);
    }

    await ChatServices.database.ref('chats/$chatRoomId').update({
      'lastMessage': initialMessages.last['message'],
      'timestamp': timestamp,
    });
  }
}
