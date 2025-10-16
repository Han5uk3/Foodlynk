import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/modules/home/home.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class ChatPage extends StatefulWidget {
  final bool isFromNotifications;
  final String? chatRoomId;

  const ChatPage({
    super.key,
    this.chatRoomId,
    required this.isFromNotifications,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ValueNotifier<bool> _chatTextNotifier = ValueNotifier(false);
  late CommunityBloc _communityBloc;

  @override
  void initState() {
    super.initState();
    _communityBloc = context.read<CommunityBloc>();
    if (widget.isFromNotifications) {
      _communityBloc.add(
        InitializeChatRoomEvent(
          isFoodSwapped: false,
          isFromDonations: false,
          roomId: widget.chatRoomId,
        ),
      );
    } else {
      // Check block status immediately if not initializing
      final roomId =
          widget.chatRoomId ?? _communityBloc.state.currentChatRoomId;
      final receiverUid = _communityBloc.state.currentReceiverUid;

      if (roomId != null && receiverUid != null) {
        _communityBloc.add(CheckBlockStatusEvent(roomId, receiverUid));
      }
    }

    _messageController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _messageController.removeListener(_handleTextChange);
    _messageController.dispose();
    _chatTextNotifier.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CommunityBloc>().add(ClearCommunityStateEvent());
      }
    });
    super.dispose();
  }

  void _handleTextChange() {
    _chatTextNotifier.value = _messageController.text.isNotEmpty;
  }

  void _navigateToMainScreen() {
    final String? roomId =
        widget.chatRoomId ?? _communityBloc.state.currentChatRoomId;
    _communityBloc.add(ClearCommunityStateEvent());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(currentIndex: 1)),
      (route) => false,
    );
  }

  void _sendMessage(
    String? fcmToken,
    String? receiverName,
    String? receiverUid,
  ) {
    // Check if user is blocked
    if (_communityBloc.state.isBlockedByMe) {
      SaverSnackBar.show(
        context: context,
        message: 'Cannot send messages. You have blocked this user.',
        isTrue: false,
      );
      return;
    }

    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _communityBloc.add(
        SendMessageEvent(
          message,
          fcmToken ?? "",
          receiverName ?? '',
          receiverUid ?? '',
        ),
      );
      _messageController.clear();
    }
  }

  // Show block confirmation dialog
  // Show block confirmation dialog with modern UI
  Future<void> _showBlockConfirmationDialog(
      String userId, String roomId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.block,
                  size: 48,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                AppLocalizations.of(context)!.blockUser,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                AppLocalizations.of(context)!.blockUserConfirmation,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.block,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true) {
      _blockUser(userId, roomId);
    }
  }

// Show unblock confirmation dialog with modern UI
  Future<void> _showUnblockConfirmationDialog(
      String userId, String roomId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: Colors.green.shade400,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                AppLocalizations.of(context)!.unblockUser,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                AppLocalizations.of(context)!.unblockUserConfirmation,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.unblock,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true) {
      _unblockUser(userId, roomId);
    }
  }

  void _blockUser(String userId, String roomId) {
    _communityBloc.add(BlockUserEvent(userId, roomId));
    SaverSnackBar.show(
      context: context,
      message: AppLocalizations.of(context)!.userBlockedSuccessfully,
      isTrue: true,
    );
  }

  void _unblockUser(String userId, String roomId) {
    _communityBloc.add(UnblockUserEvent(userId, roomId));
    SaverSnackBar.show(
      context: context,
      message: AppLocalizations.of(context)!.userUnblockedSuccessfully,
      isTrue: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateToMainScreen();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: saverAppBar(
          AppLocalizations.of(context)!.chat,
          context,
          isneedtopop: true,
          iswhite: true,
          onpop: () => _navigateToMainScreen(),
          actions: [
            BlocBuilder<CommunityBloc, CommunityState>(
              buildWhen: (previous, current) =>
                  previous.isBlockedByMe != current.isBlockedByMe,
              builder: (context, state) {
                if (state.isBlockedByMe) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  icon: Icon(
                    state.isBlockedByMe
                        ? Icons.check_circle_outline
                        : Icons.block,
                    color: state.isBlockedByMe ? Colors.white : Colors.red,
                  ),
                  onPressed: () {
                    final roomId = widget.chatRoomId ?? state.currentChatRoomId;
                    final receiverUid = state.currentReceiverUid ?? '';

                    if (state.isBlockedByMe) {
                    } else {
                      _showBlockConfirmationDialog(receiverUid, roomId ?? '');
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<CommunityBloc, CommunityState>(
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.errorMessage != current.errorMessage ||
              previous.isBlockedByMe != current.isBlockedByMe,
          builder: (context, state) {
            if (state.status == ChatStatus.loading) {
              return const Center(child: SaverLoader());
            }
            if (state.status == ChatStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'An unexpected error occurred',
                ),
              );
            }

            // Show blocked state UI
            if (state.isBlockedByMe) {
              return _BlockedUserView(
                onUnblock: () {
                  final roomId = widget.chatRoomId ?? state.currentChatRoomId;
                  final receiverUid = state.currentReceiverUid ?? '';
                  _showUnblockConfirmationDialog(receiverUid, roomId ?? '');
                },
              );
            }

            return Column(
              children: [
                _ChatHeader(),
                _MessagesBody(),
                _ChatFooter(
                  controller: _messageController,
                  textNotifier: _chatTextNotifier,
                  onSend: () {
                    final userMap = _communityBloc.state.userDetails.isNotEmpty
                        ? _communityBloc.state.userDetails.values.first
                        : {};

                    _sendMessage(
                      userMap['fcmToken'],
                      "${userMap['firstName'] ?? 'N/A'} ${userMap['lastName'] ?? ''}",
                      userMap['uid'],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Blocked User View Widget
class _BlockedUserView extends StatelessWidget {
  final VoidCallback onUnblock;

  const _BlockedUserView({required this.onUnblock});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.youBlockedThisUser,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.unblockToSendMessages,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onUnblock,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(
                AppLocalizations.of(context)!.unblockUser,
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      buildWhen: (previous, current) =>
          previous.userDetails != current.userDetails ||
          previous.currentReceiverUid != current.currentReceiverUid,
      builder: (context, state) {
        final Map<String, dynamic> userMap = state.currentReceiverUid != null &&
                state.userDetails.containsKey(state.currentReceiverUid)
            ? state.userDetails[state.currentReceiverUid]!
            : state.userDetails.isNotEmpty
                ? state.userDetails.values.first
                : {};

        final receiverName =
            "${userMap['firstName'] ?? 'N/A'} ${userMap['lastName'] ?? ''}";
        final phoneNumber = userMap['phoneNumber'] ?? 'N/A';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          height: 100,
          decoration: BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receiverName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      phoneNumber.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColor.lightGrey200,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MessagesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      buildWhen: (previous, current) =>
          previous.messages != current.messages ||
          previous.status != current.status,
      builder: (context, state) {
        if (state.status == ChatStatus.loading) {
          return const Expanded(child: Center(child: SaverLoader()));
        }

        if (state.messages.isEmpty && state.status == ChatStatus.loaded) {
          return Expanded(
            child: Center(
              child: Text(AppLocalizations.of(context)!.noMessageYet),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final msg = state.messages[state.messages.length - 1 - index];
              final isMe = msg.senderUID == Services.uid;
              final time = DateFormat.jm().format(msg.timestamp);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 14,
                ),
                child: Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft:
                            isMe ? const Radius.circular(16) : Radius.zero,
                        bottomRight:
                            isMe ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.message,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 12,
                                color: isMe ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            if (isMe) ...[const SizedBox(width: 6)],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ChatFooter extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> textNotifier;
  final VoidCallback onSend;

  const _ChatFooter({
    required this.controller,
    required this.textNotifier,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.lightGrey200),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      onSend();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.typeAMessage,
                    hintStyle: TextStyle(color: AppColor.lightGrey200),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: textNotifier,
                builder: (context, hasText, child) {
                  return hasText
                      ? IconButton(
                          onPressed: onSend,
                          icon: Icon(Icons.send, color: Colors.grey.shade800),
                        )
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
