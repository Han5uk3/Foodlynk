import 'package:flutter/material.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class EmptyList extends StatelessWidget {
  final String? message;
  final String? subMessage;
  const EmptyList({super.key, this.message, this.subMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 48, color: AppColor.lightGrey200),
          SizedBox(height: 12),
          Text(
            message ?? "No items found",
            style: TextStyle(fontSize: 16, color: AppColor.lightGrey200),
          ),
          if (subMessage != null) ...[
            SizedBox(height: 8),
            Text(
              subMessage!,
              style: TextStyle(fontSize: 14, color: AppColor.lightGrey200),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}