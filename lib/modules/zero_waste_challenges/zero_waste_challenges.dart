import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class ZeroWasteChallenges extends StatefulWidget {
  const ZeroWasteChallenges({super.key});

  @override
  State<ZeroWasteChallenges> createState() => _ZeroWasteChallengesState();
}

class _ZeroWasteChallengesState extends State<ZeroWasteChallenges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        "Zero Waste Challenges",
        context,
        iconColor: AppColor.white,
        textColor: AppColor.white,
        isneedtopop: true,
        iswhite: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Card(
              color: AppColor.lightYellow,
              elevation: 3,
              child: SizedBox(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total points"),
                      SvgPicture.asset("assets/icons/Icon.svg"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
