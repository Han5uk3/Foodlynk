import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/modules/community/chat_page.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar("Community", context, isneedtopop: false),
      body: BlocListener<CommunityBloc, CommunityState>(
        listener: (context, state) {
          if (state.status == ChatStatus.goToChatPage) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(isFromNotifications: false),
              ),
            );
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        switch (state.status) {
          case ChatStatus.loading:
            return SaverLoader();
          case ChatStatus.error:
            return Center(
              child: Text(
                state.errorMessage ?? "An error occurred",
                style: const TextStyle(color: Colors.red),
              ),
            );
          case ChatStatus.loaded:
            return _buildChatRoomsList(context, state);
          default:
            return Text("DDDD");
        }
      },
    );
  }

  Widget _buildChatRoomsList(BuildContext context, CommunityState state) {
    final rooms = state.chatRooms;
    final userDetails = state.userDetails;

    if (rooms.isEmpty) {
      return const Center(child: Text("No chat rooms found"));
    }
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        final user = userDetails[room['receiverUID']] ?? {};
        final unreadCount = room["unread_count"]?[Services.uid] ?? 0;
        final bool isUnread = unreadCount > 0;
        final lastMessage = room['lastMessage'] ?? {};
        String messageText = lastMessage['text'] ?? '';
        String time =
            lastMessage['timestamp'] != null
                ? DateFormat.jm().format(
                  DateTime.fromMillisecondsSinceEpoch(lastMessage['timestamp']),
                )
                : '';
        return Padding(
          padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
          child: GestureDetector(
            onTap:
                () => context.read<CommunityBloc>().add(
                  InitializeChatRoomEvent(
                    roomId: room['roomId'],
                    isFoodSwapped: false,
                    isFromDonations: false,
                  ),
                ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.lightGrey),
                color: isUnread ? Colors.blue.withOpacity(0.05) : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 35),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${user["firstName"]} ${user["lastName"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    messageText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(
                                      color:
                                          isUnread
                                              ? Colors.black87
                                              : AppColor.lightGrey200,
                                      fontWeight:
                                          isUnread
                                              ? FontWeight.w500
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (room["unreadCount"] != null &&
                                    room["unreadCount"] > 0 &&
                                    room["lastSenderUID"] != Services.uid)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blue,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${room["unreadCount"]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
