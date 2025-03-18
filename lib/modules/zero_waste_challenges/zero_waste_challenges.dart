
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/modules/zero_waste_challenges/clean_plate_challenge.dart';

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.amber.shade800,
                      Colors.amber.shade700,
                      Colors.amber.shade400,
                      Colors.yellow.shade300,
                      Colors.yellow.shade200,
                      Colors.yellow.shade100,
                      Colors.yellow.shade200,
                      Colors.amber.shade300,
                      Colors.amber.shade400,
                      Colors.amber.shade700,
                      Colors.amber.shade800,
                    ],
                  ),
                ),
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          "Total points",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Row(
                          children: [
                            loadsvg("assets/icons/coin.svg"),
                            Text(
                              " 10",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 45),
            Text(
              "Take a challenge, save food, and earn rewards",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => CleanPlateChallenge(),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                color: AppColor.white,
                child: SizedBox(
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: loadsvg("assets/icons/cleanplate.svg"),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 3,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Clean Plate Challenge",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 25,
                                  padding: EdgeInsets.symmetric(horizontal: 7),
                                  decoration: BoxDecoration(
                                    color: AppColor.pointColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "+10 points",
                                      style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Text(
                              "Finish your entire meal without leftovers and upload a before & after photo.",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
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
