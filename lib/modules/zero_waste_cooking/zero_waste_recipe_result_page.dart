import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class ZeroWasteRecipeResultPage extends StatefulWidget {
  const ZeroWasteRecipeResultPage({super.key});

  @override
  State<ZeroWasteRecipeResultPage> createState() =>
      _ZeroWasteRecipeResultPageState();
}

class _ZeroWasteRecipeResultPageState extends State<ZeroWasteRecipeResultPage> {
  final List<Map<String, String>> nutritionData = [
    {'label': 'Carbs', 'value': 'x2 nos'},
    {'label': 'Protein', 'value': 'x2 nos'},
    {'label': 'Fats', 'value': 'x2 nos'},
    {'label': 'Fiber', 'value': 'x2 nos'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        "Portion Plan",
        context,
        iswhite: true,
        isneedtopop: true,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: 6),
            _buildBanner(),
            SizedBox(height: 10),
            Text("Breakfast for 2 people"),
            Container(
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.lightGrey200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      "Protein: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text("~150g per person"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.lightGrey200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 15),
                            child: Text(
                              "Vegetables: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text("~100g per person"),
                        ],
                      ),
                      Divider(thickness: 2, color: Colors.grey.shade200),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          "Available Ingredients",
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height:
                            nutritionData.length *
                            85, // Adjust based on item height
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics:
                              NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                          itemCount: nutritionData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${nutritionData[index]['label']}: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(nutritionData[index]['value'] ?? ""),
                                      Spacer(),
                                      Icon(
                                        Icons.check_circle_outline_outlined,
                                        size: 35,
                                        color: AppColor.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.lightGrey200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      "Carbs: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text("~50g per person"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBanner() {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 2,
          child: CustomPaint(
            painter: DiagonalBackgroundPainter(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Text(
                    "No food waste! These portions are just right for 2 people.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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

    paint.color = Color.fromARGB(
      100,
      246,
      231,
      178,
    ); //rgba(246, 231, 178, 0.29)
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
