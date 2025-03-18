import 'package:flutter/material.dart';

PreferredSizeWidget saverAppBar(
  String title,
  BuildContext context, {
  bool isneedtopop = false,
  bool iswhite = true,
  List<Widget>? actions,
}) {
  return AppBar(
    toolbarHeight: 75,
    title: Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
    leadingWidth: isneedtopop ? 40 : 0,
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
    backgroundColor: iswhite ? Colors.white : Colors.red,
    actions: actions,
  );
}
