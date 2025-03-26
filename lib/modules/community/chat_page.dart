import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  TextEditingController chatTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> chatTextNotifier = ValueNotifier(false);

  List<Map<String, dynamic>> chats = [
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {
      "content":
          "hello, my manzdfvvvvvvddddddvvvvvvvvvvvvvvvvvvvvvvvvszzzzzeeeeeeeeeeeeeeeeecdddvvzzzzzzzzzzzccc!",
      "time": "2:00 PM",
      "sent": true,
    },
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {
      "content":
          "hello, mvdzsssssssssssssssssssssssssssserrrrrrrrrrrrrrrggggggggggggggggccccxxxxxxxxxxxxxxxxzZSEeffffffdzxsfcy man!",
      "time": "2:00 PM",
      "sent": false,
    },
    {"content": "hello, my man!", "time": "2:00 PM", "sent": true},
    {"content": "hello, my man!", "time": "2:00 PM", "sent": false},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SafeArea(
        child: AnimatedPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildChatFooter(),
          duration: const Duration(milliseconds: 150),
        ),
      ),
      appBar: saverAppBar("Chat", context, isneedtopop: true, iswhite: true),
      body: _buildbody(),
    );
  }

  _buildbody() {
    return Column(
      children: [_buildChatHeader(), Expanded(child: _buildChatBody())],
    );
  }

  _buildChatHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14),
      height: 100,
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 30),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 8),
                Text(
                  "(+966) 552271278",
                  style: TextStyle(fontSize: 18, color: AppColor.lightGrey200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildChatFooter() {
    return Padding(
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
                controller: chatTextController,
                onChanged: (text) {
                  chatTextNotifier.value = text.isNotEmpty;
                },
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
                      onPressed: () {
                        // Implement send action
                      },
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
    );
  }

  Widget _buildChatBody() {
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return ListView.builder(
          reverse: true,
          itemCount: chats.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            bool isSent = chats[index]["sent"];

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              child: Row(
                mainAxisAlignment:
                    isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSent ? Colors.blue : Colors.grey.shade100,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft:
                              isSent ? Radius.circular(16) : Radius.circular(0),
                          bottomRight:
                              isSent ? Radius.circular(0) : Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            isSent
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Text(
                            chats[index]["content"],
                            style: TextStyle(
                              color: isSent ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            chats[index]["time"],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSent ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
