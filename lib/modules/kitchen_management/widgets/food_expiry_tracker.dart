import 'package:flutter/material.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodExpiryTracker extends StatelessWidget {
  const FoodExpiryTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Services.getUserDetails(uid: Services.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        }
        var userData = snapshot.data?.docs.first.data();
        double itemAddedQuantity =
            userData?.monthlyItemQuantityAddedCount?.toDouble() ?? 0.0;
        double itemRemovedQuantity =
            userData?.monthlyItemQuantityRemovedCount?.toDouble() ?? 0.0;
        double percentage =
            (itemRemovedQuantity != 0)
                ? (itemRemovedQuantity / itemAddedQuantity) * 100
                : 0.0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: CustomPaint(
            painter: DiagonalBackgroundPainter(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: -1.57,
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            strokeWidth: 8,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.pointColor,
                            ),
                            backgroundColor: const Color.fromARGB(
                              130,
                              249,
                              219,
                              116,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "${percentage.toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.pointColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.youveConsumed} ${percentage.toStringAsFixed(0)}% ${AppLocalizations.of(context)!.ofYourFoodBeforeExpiry}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DiagonalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    Path topLeftPath =
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width * 0.53, 0)
          ..lineTo(size.width * 0.76, size.height)
          ..lineTo(0, size.height)
          ..close();

    paint.color = Color.fromARGB(100, 246, 231, 178);
    canvas.drawPath(topLeftPath, paint);

    Path bottomRightPath =
        Path()
          ..moveTo(size.width, 0)
          ..lineTo(size.width * 0.53, 0)
          ..lineTo(size.width * 0.76, size.height)
          ..lineTo(size.width, size.height)
          ..close();

    paint.color = Color.fromARGB(200, 246, 231, 178);
    canvas.drawPath(bottomRightPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
