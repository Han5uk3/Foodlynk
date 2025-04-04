import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/models/notification_model.dart';
import 'package:saver_bbk_main/modules/notifications/bloc/notification_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
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

  bool isClearing = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_fadeController);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _handleClearAllNotifications() {
    setState(() {
      isClearing = true;
    });
    _fadeController.forward().then((_) {
      context.read<NotificationBloc>().add(
        ClearAllNotificationsEvent(uid: Services.uid ?? ""),
      );

      // Reset animation after a short delay to show the empty state
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            isClearing = false;
          });
          _fadeController.reset();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        "Notifications",
        context,
        isneedtopop: false,
        actions: [
          notifications.isEmpty
              ? Container()
              : TextButton.icon(
                onPressed: isClearing ? null : _handleClearAllNotifications,
                icon:
                    isClearing
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.red,
                            ),
                          ),
                        )
                        : Icon(Icons.delete_outlined, color: AppColor.red),
                label: Text(
                  isClearing ? "Clearing..." : "Clear",
                  style: TextStyle(color: AppColor.red),
                ),
              ),
        ],
      ),
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationDeleteError) {
            setState(() {
              isClearing = false;
              _fadeController.reset();
            });
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          } else if (state is NotificationsClearedSuccessfully) {
            SaverSnackBar.show(
              context: context,
              message: "All notifications cleared successfully",
              isTrue: true,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: _buildbody(),
        ),
      ),
    );
  }

  Widget _buildbody() {
    return StreamBuilder<List<NotificationModel>>(
      stream: Services.getUserNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !isClearing) {
          return SaverLoader();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Something went wrong: ${snapshot.error}",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        notifications = snapshot.data ?? [];

        if (notifications.isEmpty) {
          return Center(
            child:
                isClearing
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.blue,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Clearing notifications...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                    : Text(
                      "No notifications found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
          );
        }

        return FadeTransition(
          opacity:
              isClearing ? _fadeAnimation : const AlwaysStoppedAnimation(1.0),
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              NotificationModel model = notifications[index];
              final iconIndex = index % getIconData.length;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 14,
                ),
                child: Dismissible(
                  key: Key(model.notificationId ?? index.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    context.read<NotificationBloc>().add(
                      DeleteNotificationEvent(
                        notificationId: model.notificationId ?? "",
                      ),
                    );
                  },
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          CupertinoIcons.trash,
                          color: Colors.white,
                          size: 25,
                        ),
                        Text(
                          "Remove Notification",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(
                        width: 3,
                        color:
                            model.type == "message"
                                ? AppColor.lightblue
                                : getIconData[iconIndex]["bgcolor"] as Color,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor:
                              model.type == "message"
                                  ? AppColor.lightblue
                                  : getIconData[iconIndex]["bgcolor"] as Color,
                          child: Icon(
                            model.type == "message"
                                ? Icons.message_outlined
                                : getIconData[iconIndex]["icon"] as IconData,
                            size: 30,
                            color:
                                model.type == "message"
                                    ? AppColor.blue
                                    : getIconData[iconIndex]["color"] as Color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    model.title ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "",
                                    // DateFormatHelper.ddmmyyyy(
                                    //   model.timestamp as DateTime,
                                    // ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  model.body ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
          ),
        );
      },
    );
  }
}
