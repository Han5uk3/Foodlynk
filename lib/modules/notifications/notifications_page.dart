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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  final Map<String, Map<String, dynamic>> _notificationTypeIcons = {
    "message": {
      "icon": Icons.message_outlined,
      "color": AppColor.blue,
      "bgcolor": AppColor.lightblue,
    },
    "food": {
      "icon": Icons.food_bank_outlined,
      "color": AppColor.red,
      "bgcolor": AppColor.lightRed,
    },
    "alert": {
      "icon": Icons.notifications_outlined,
      "color": AppColor.red,
      "bgcolor": AppColor.lightRed,
    },
    "event": {
      "icon": Icons.date_range_outlined,
      "color": AppColor.green,
      "bgcolor": AppColor.lightGreen,
    },
  };

  final List<Map<String, dynamic>> _fallbackIconData = [
    {
      "icon": Icons.info_outline,
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationBloc>().add(FetchNotificationsEvent());
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _handleClearAllNotifications() {
    if (notifications.isEmpty) return;

    setState(() {
      isClearing = true;
    });

    _fadeController.forward().then((_) {
      context.read<NotificationBloc>().add(
        ClearAllNotificationsEvent(uid: Services.uid ?? ""),
      );

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

  Map<String, dynamic> _getIconDataForType(String? type, int index) {
    if (type != null && _notificationTypeIcons.containsKey(type)) {
      return _notificationTypeIcons[type]!;
    }

    return _fallbackIconData[index % _fallbackIconData.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        AppLocalizations.of(context)!.notification,
        context,
        isneedtopop: false,
        actions: [
          StreamBuilder<List<NotificationModel>>(
            stream: Services.getUserNotifications(),
            builder: (context, snapshot) {
              final hasNotifications =
                  snapshot.hasData &&
                  (snapshot.data?.isNotEmpty ?? false) &&
                  !isClearing;

              if (!hasNotifications) {
                return Container();
              }

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton.icon(
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
                    isClearing
                        ? "Clearing..."
                        : AppLocalizations.of(context)!.clearAll,
                    style: TextStyle(color: AppColor.red),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
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
            setState(() {
              notifications = [];
              isClearing = false;
            });
            SaverSnackBar.show(
              context: context,
              message: "All notifications cleared successfully",
              isTrue: true,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: _buildbody(state),
          );
        },
      ),
    );
  }

  Widget _buildbody([NotificationState? state]) {
    return StreamBuilder<List<NotificationModel>>(
      stream: Services.getUserNotifications(),
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.waiting &&
                !isClearing) ||
            state is NotificationsLoading) {
          return const Center(child: SaverLoader());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: AppColor.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  "Something went wrong",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${snapshot.error}",
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (snapshot.hasData) {
          notifications = snapshot.data ?? [];
        }

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
                        const SizedBox(height: 16),
                        const Text(
                          "Clearing notifications...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noNotificationsFound,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
          );
        }

        return FadeTransition(
          opacity:
              isClearing ? _fadeAnimation : const AlwaysStoppedAnimation(1.0),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              NotificationModel model = notifications[index];
              final iconData = _getIconDataForType(model.type, index);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Dismissible(
                  key: Key(model.notificationId ?? index.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
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
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          CupertinoIcons.trash,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.remove,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(
                        width: 2,
                        color: iconData["bgcolor"] as Color,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: iconData["bgcolor"],
                          child: Icon(
                            iconData["icon"],
                            size: 28,
                            color: iconData["color"],
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
                                  Flexible(
                                    flex: 3,
                                    child: Text(
                                      model.title ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (model.timestamp != null)
                                    Text(
                                      _formatTimestamp(model.timestamp),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                model.body ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[800],
                                  height: 1.3,
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

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is DateTime) {
      return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
    }
    return "";
  }
}
