import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/modules/community/chat_page.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Map<String, String>> content = [
    {
      "name": "David Wayne",
      "text": "Thanks a bunch! Have a great day! 😊",
      "time": "10:25 AM",
      "stamp": "5",
    },
    {
      "name": "Edward Davidson",
      "text": "Great, thanks so much! 💫",
      "time": "10:25 PM",
      "stamp": "19",
    },
    {
      "name": "Angela Kelly",
      "text": "Appreciate it! See you soon! 🚀",
      "time": "1:25 PM",
      "stamp": "2",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar("Community", context, isneedtopop: false),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: content.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => ChatPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.lightGrey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      content[index]["name"]!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    Text(
                                      content[index]["time"]!,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        content[index]["text"]!,
                                        style: const TextStyle(
                                          color: AppColor.lightGrey200,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 50),
                                      width: 18,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue,
                                      ),
                                      child: Center(
                                        child: Text(
                                          content[index]["stamp"]!,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
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
      },
    );
  }
}
