import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool? isBold;
  const Label({super.key, required this.text, this.style, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          style ??
          TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: (isBold ?? false) ? FontWeight.bold : FontWeight.normal,
          ),
    );
  }
}
