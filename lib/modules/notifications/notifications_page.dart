import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar("Notifications", context, isneedtopop: false),
    );
  }
}
