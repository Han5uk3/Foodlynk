import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class Coins extends StatelessWidget {
  final int coins;
  const Coins({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: coins > 0 ? 60 + (coins.toString().length * 7.0) : 60,
      height: 30,
      padding: EdgeInsets.only(left: 5, right: 10),
      decoration: BoxDecoration(
        color: AppColor.yellow150,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(12),
          right: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          loadsvg("assets/icons/coin.svg"),
          SizedBox(width: 1),
          Text(
            coins.toString(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColor.yellow600,
            ),
          ),
        ],
      ),
    );
  }
}
