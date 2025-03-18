import 'package:flutter/material.dart';
import 'package:saver_bbk_main/styles/colors.dart';

PreferredSizeWidget saverAppBar(
  String title,
  BuildContext context, {
  bool isneedtopop = false,
  bool iswhite = true,
  List<Widget>? actions,
}) {
  return AppBar(
    scrolledUnderElevation: 0,
    toolbarHeight: 75,
    title: Text(
      title,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    centerTitle: false,
    shape: BorderDirectional(
      bottom: BorderSide(color: Colors.grey.shade100, width: 3),
    ),
    leading:
        isneedtopop
            ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
            : SizedBox.shrink(),
    backgroundColor: iswhite ? AppColor.white : Colors.red,
    actions: actions,
  );
}
