part of 'community_bloc.dart';

class CommunityState extends Equatable {
  final List<Map<String, dynamic>> chatRooms;
  final Map<String, dynamic> userDetails;
  final String? currentChatRoomId;
  final String? currentReceiverUid;
  final List<ChatMessage> messages;
  final ChatStatus status;
  final String? errorMessage;

  const CommunityState({
    this.chatRooms = const [],
    this.userDetails = const {},
    this.currentChatRoomId,
    this.currentReceiverUid,
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.errorMessage,
  });

  CommunityState copyWith({
    List<Map<String, dynamic>>? chatRooms,
    Map<String, dynamic>? userDetails,
    String? currentChatRoomId,
    String? currentReceiverUid,
    List<ChatMessage>? messages,
    ChatStatus? status,
    String? errorMessage,
  }) {
    return CommunityState(
      chatRooms: chatRooms ?? this.chatRooms,
      userDetails: userDetails ?? this.userDetails,
      currentChatRoomId: currentChatRoomId ?? this.currentChatRoomId,
      currentReceiverUid: currentReceiverUid ?? this.currentReceiverUid,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    chatRooms,
    userDetails,
    currentChatRoomId,
    currentReceiverUid,
    messages,
    status,
    errorMessage,
  ];
}

enum ChatStatus { initial, loading, loaded, error, sending, goToChatPage }
