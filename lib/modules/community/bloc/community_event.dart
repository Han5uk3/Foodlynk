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
  String? fcmToken;

  final bool isFoodSwapped;
  final bool isFromDonations;
  final bool isFromBeneficiary;
  final BuildContext context;
  InitializeChatRoomEvent({
    this.receiverUid,
    this.roomId,
    this.fcmToken,
    required this.context,
    required this.isFoodSwapped,
    required this.isFromDonations,
    this.isFromBeneficiary = false,
  });
  @override
  List<Object> get props => [
    receiverUid ?? "",
    isFoodSwapped,
    roomId ?? '',
    fcmToken ?? '',
    isFromDonations,
  ];
}

class LoadMessagesEvent extends CommunityEvent {}

class SendMessageEvent extends CommunityEvent {
  final String reciversName;
  final String reciversUid;
  final String message;
  final String? fcmToken;
  const SendMessageEvent(
    this.message,
    this.fcmToken,
    this.reciversName,
    this.reciversUid,
  );

  @override
  List<Object> get props => [message, reciversName, fcmToken!, reciversUid];
}

class UpdateMessagesEvent extends CommunityEvent {
  final List<ChatMessage> messages;
  const UpdateMessagesEvent(this.messages);

  @override
  List<Object> get props => [messages];
}

class ClearCommunityStateEvent extends CommunityEvent {}

class UserLeftChatEvent extends CommunityEvent {}
