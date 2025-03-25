import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/models/users_model.dart';

class FoodSwapRequest extends StatefulWidget {
  const FoodSwapRequest({super.key, required this.items});

  final Items items;

  @override
  State<FoodSwapRequest> createState() => _FoodSwapRequestState();
}

class _FoodSwapRequestState extends State<FoodSwapRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        "Food Swap Request",
        context,
        isneedchat: true,
        isneedtopop: true,
        iswhite: true,
      ),
    );
  }
}
