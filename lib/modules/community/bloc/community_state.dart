part of 'community_bloc.dart';

class CommunityState extends Equatable {
  final List<Map<String, dynamic>> chatRooms;
  final Map<String, dynamic> userDetails;
  final String? currentChatRoomId;
  final String? currentReceiverUid;
  final List<ChatMessage> messages;
  final ChatStatus status;
  final String? errorMessage;
  
  // Blocking fields
  final bool isBlockedByMe;
  final bool isBlockedByOther;
  final String? blockedUserId;

  const CommunityState({
    this.chatRooms = const [],
    this.userDetails = const {},
    this.currentChatRoomId,
    this.currentReceiverUid,
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.errorMessage,
    
    // Blocking parameters
    this.isBlockedByMe = false,
    this.isBlockedByOther = false,
    this.blockedUserId,
  });

  CommunityState copyWith({
    List<Map<String, dynamic>>? chatRooms,
    Map<String, dynamic>? userDetails,
    String? currentChatRoomId,
    String? currentReceiverUid,
    List<ChatMessage>? messages,
    ChatStatus? status,
    String? errorMessage,
    
    // Blocking parameters
    bool? isBlockedByMe,
    bool? isBlockedByOther,
    Object? blockedUserId = _undefined, // Use sentinel value
  }) {
    return CommunityState(
      chatRooms: chatRooms ?? this.chatRooms,
      userDetails: userDetails ?? this.userDetails,
      currentChatRoomId: currentChatRoomId ?? this.currentChatRoomId,
      currentReceiverUid: currentReceiverUid ?? this.currentReceiverUid,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      
      // Blocking assignments with proper null handling
      isBlockedByMe: isBlockedByMe ?? this.isBlockedByMe,
      isBlockedByOther: isBlockedByOther ?? this.isBlockedByOther,
      blockedUserId: blockedUserId == _undefined 
          ? this.blockedUserId 
          : blockedUserId as String?,
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
    
    // Blocking props
    isBlockedByMe,
    isBlockedByOther,
    blockedUserId,
  ];
}

// Sentinel value for nullable field handling
const _undefined = Object();

enum ChatStatus { initial, loading, loaded, error, sending, goToChatPage }
