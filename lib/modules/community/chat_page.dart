import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/modules/home/home.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class ChatPage extends StatefulWidget {
  final bool isFromFoodSwap;
  final bool isFromNotifications;
  String? chatRoomId;
  ChatPage({
    super.key,
    this.chatRoomId,
    required this.isFromFoodSwap,
    required this.isFromNotifications,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    if (widget.isFromNotifications) {
      context.read<CommunityBloc>().add(
        InitializeChatRoomEvent(
          isFoodSwapped: false,
          roomId: widget.chatRoomId,
        ),
      );
    }
    super.initState();
  }

  final ValueNotifier<bool> chatTextNotifier = ValueNotifier(false);

  String? fcmToken;

  String? reciverName;
  String? reciverUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: saverAppBar(
        "Chat",
        context,
        isneedtopop: true,
        iswhite: true,
        onpop:
            () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(currentIndex: 1),
              ),
              (route) => false,
            ),
      ),
      body: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state.status == ChatStatus.loading) {
            return Center(child: SaverLoader());
          }
          if (state.status == ChatStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'An unexpected error occurred'),
            );
          }
          return Column(
            children: [
              _buildChatHeader(),
              _buildMessagesBody(state),
              _buildChatFooter(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatHeader() {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        final userMap =
            state.userDetails.isNotEmpty ? state.userDetails.values.first : {};
        fcmToken = userMap['fcmToken'];
        reciverName =
            "${userMap['firstName'] ?? 'N/A'} ${userMap['lastName'] ?? ''}";
        reciverUid = userMap['uid'];
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
                      reciverName ?? "",
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

  Widget _buildChatBody(CommunityState state) {
    return ListView.builder(
      reverse: true,
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final msg = state.messages[state.messages.length - 1 - index];
        bool isMe = msg.senderUID == Services.uid;
        String time = DateFormat.jm().format(msg.timestamp);

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          child: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: isMe ? Radius.circular(16) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.message,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: isMe ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessagesBody(CommunityState state) {
    if (state.status == ChatStatus.loading) {
      return const Expanded(child: Center(child: SaverLoader()));
    }

    if (state.messages.isEmpty && state.status == ChatStatus.loaded) {
      return const Expanded(child: Center(child: Text("No messages yet")));
    }

    return Expanded(child: _buildChatBody(state));
  }

  Widget _buildChatFooter(BuildContext context, CommunityState state) {
    final TextEditingController messageController = TextEditingController();

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
                  controller: messageController,
                  onChanged: (text) {
                    chatTextNotifier.value = text.isNotEmpty;
                  },
                  onSubmitted:
                      (value) => context.read<CommunityBloc>().add(
                        SendMessageEvent(
                          messageController.text.trim(),
                          fcmToken ?? "",
                          reciverName ?? '',
                          reciverUid ?? '',
                        ),
                      ),

                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: AppColor.lightGrey200),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: chatTextNotifier,
                builder: (context, hasText, child) {
                  return hasText
                      ? IconButton(
                        onPressed:
                            () => context.read<CommunityBloc>().add(
                              SendMessageEvent(
                                messageController.text.trim(),
                                fcmToken ?? "",
                                reciverName ?? '',
                                reciverUid ?? '',
                              ),
                            ),
                        icon: Icon(Icons.send, color: Colors.grey.shade800),
                      )
                      : Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.photo_camera_outlined,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.attach_file_outlined,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
