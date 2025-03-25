import 'package:flutter/material.dart';
import 'package:saver_bbk_main/styles/colors.dart';

PreferredSizeWidget saverAppBar(
  String title,
  BuildContext context, {
  PreferredSizeWidget? bottom,
  Color textColor = AppColor.black,
  Color iconColor = AppColor.black,
  bool isneedtopop = false,
  void Function()? onpop,
  bool iswhite = true,
  bool isneedchat = false,

  List<Widget>? actions,
}) {
  return AppBar(
    bottom: bottom,
    scrolledUnderElevation: 0,
    centerTitle: false,
    toolbarHeight: 75,
    title: Padding(
      padding: isneedtopop ? EdgeInsets.all(0) : EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    ),
    shape: BorderDirectional(
      bottom: BorderSide(color: Colors.grey.shade100, width: 1),
    ),
    leading:
        isneedtopop
            ? IconButton(
              icon: Icon(Icons.arrow_back, color: iconColor),
              onPressed: onpop ?? () => Navigator.pop(context),
            )
            : null,
    backgroundColor: iswhite ? AppColor.white : AppColor.appbarColor,
    actions:
        isneedchat
            ? [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chat_bubble, color: iconColor),
              ),
            ]
            : actions,
  );
}
