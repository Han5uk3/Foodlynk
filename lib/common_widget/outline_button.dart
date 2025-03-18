import 'package:flutter/material.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class SaverOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final double padding;
  final TextStyle? style;

  const SaverOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.borderColor = AppColor.primaryColor,
    this.textColor = AppColor.primaryColor,
    this.borderRadius = 8.0,
    this.padding = 16.0,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: 2.0),
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: style ?? TextStyle(color: textColor, fontSize: 14.0),
      ),
    );
  }
}
