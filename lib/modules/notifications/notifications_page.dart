import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notificationsList = [
    {
      "title": "Food Swap Request",
      "description": "Alex wants to swap his 2 apples for your 1 banana.",
      "date": "27/03/2025",
      "time": "05:30 PM",
    },
    {
      "title": "Donation Accepted",
      "description": "Alex has accepted your donation of 5 Apples.",
      "date": "28/03/2025",
      "time": "12:05 PM",
    },
    {
      "title": "Expiring Soon!",
      "description": "Bananas in your kitchen will expire in 3 days.",
      "date": "29/03/2025",
      "time": "10:25 AM",
    },
  ];
  List<Map<String, dynamic>> getIconData = [
    {
      "icon": Icons.food_bank_outlined,
      "color": AppColor.blue,
      "bgcolor": AppColor.lightblue,
    },
    {
      "icon": Icons.notifications_outlined,
      "color": AppColor.red,
      "bgcolor": AppColor.lightRed,
    },
    {
      "icon": Icons.date_range_outlined,
      "color": AppColor.green,
      "bgcolor": AppColor.lightGreen,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar("Notifications", context, isneedtopop: false),
      body: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: _buildbody(),
      ),
    );
  }

  Widget _buildbody() {
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: notificationsList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
              child: Dismissible(
                key: Key(index.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  // notification dismiss action
                },
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.trash, color: Colors.white, size: 25),
                      Text(
                        "Remove Notification",
                        style: TextStyle(color: AppColor.white),
                      ),
                    ],
                  ),
                ),

                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    border: Border.all(
                      width: 3,
                      color: getIconData[index]["bgcolor"] as Color,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: getIconData[index]["bgcolor"] as Color,
                        child: Center(
                          child: Icon(
                            getIconData[index]["icon"] as IconData,
                            size: 36,
                            color: getIconData[index]["color"] as Color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notificationsList[index]["title"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      notificationsList[index]["date"],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                    Text(
                                      notificationsList[index]["time"],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Text(
                                textAlign: TextAlign.start,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                notificationsList[index]["description"],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
