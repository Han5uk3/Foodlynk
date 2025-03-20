import 'package:flutter/material.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class SaverButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double padding;

  const SaverButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColor.primaryColor,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.padding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: textColor, fontSize: 14.0)),
      ),
    );
  }
}
