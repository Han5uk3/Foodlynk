// ignore_for_file: must_be_immutable

part of 'community_bloc.dart';

sealed class CommunityEvent extends Equatable {
  const CommunityEvent();

  @override
  List<Object> get props => [];
}

class LoadChatRoomsEvent extends CommunityEvent {}

class FetchUserDetailsEvent extends CommunityEvent {
  final List<Map<String, dynamic>> rooms;
  final Map<String, Map<String, dynamic>> userDetails;

  const FetchUserDetailsEvent(this.rooms, this.userDetails);

  @override
  List<Object> get props => [rooms, userDetails];
}

class InitializeChatRoomEvent extends CommunityEvent {
  String? receiverUid;
  String? roomId;
  final bool isFoodSwapped;
  InitializeChatRoomEvent({
    this.receiverUid,
    this.roomId,
    required this.isFoodSwapped,
  });
  @override
  List<Object> get props => [receiverUid ?? "", isFoodSwapped, roomId ?? ''];
}

class LoadMessagesEvent extends CommunityEvent {}

class SendMessageEvent extends CommunityEvent {
  final String reciversName;
  final String message;
  final String fcmToken;
  const SendMessageEvent(this.message, this.fcmToken, this.reciversName);

  @override
  List<Object> get props => [message, reciversName, fcmToken];
}

class UpdateMessagesEvent extends CommunityEvent {
  final List<ChatMessage> messages;
  const UpdateMessagesEvent(this.messages);

  @override
  List<Object> get props => [messages];
}
