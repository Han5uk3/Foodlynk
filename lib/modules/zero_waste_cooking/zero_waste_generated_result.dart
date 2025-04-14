import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/models/protein_plan_model.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ZeroWasteRecipeResultPage extends StatefulWidget {
  final GenaratedProteinPlanModel genaratedPlanModel;
  final String selectedMeal;

  const ZeroWasteRecipeResultPage({
    super.key,
    required this.genaratedPlanModel,
    required this.selectedMeal,
  });

  @override
  State<ZeroWasteRecipeResultPage> createState() =>
      _ZeroWasteRecipeResultPageState();
}

class _ZeroWasteRecipeResultPageState extends State<ZeroWasteRecipeResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        AppLocalizations.of(context)!.portionPlan,
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
        padding: const EdgeInsets.only(
          left: 14.0,
          right: 14.0,
          top: 14.0,
          bottom: 35.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            _buildBanner(),
            SizedBox(height: 10),
            Text(
              "${widget.selectedMeal} ${AppLocalizations.of(context)!.forText} ${widget.genaratedPlanModel.data?.numberOfServings} ${AppLocalizations.of(context)!.people}",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),
            Text(
              "${AppLocalizations.of(context)!.recipeName}:${widget.genaratedPlanModel.data?.recipeName}",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
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
                      "${AppLocalizations.of(context)!.protein}: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "~${widget.genaratedPlanModel.data?.nutritionalInfo?.protein} ${AppLocalizations.of(context)!.perPerson}",
                    ),
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
                              AppLocalizations.of(context)!.vegetables,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            "~${widget.genaratedPlanModel.data?.nutritionalInfo?.calories} ${AppLocalizations.of(context)!.perPerson}",
                          ),
                        ],
                      ),
                      Divider(thickness: 2, color: Colors.grey.shade200),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          AppLocalizations.of(context)!.availableIngredients,
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height:
                            widget
                                .genaratedPlanModel
                                .data!
                                .ingredients!
                                .length *
                            85,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              widget
                                  .genaratedPlanModel
                                  .data
                                  ?.ingredients!
                                  .length,
                          itemBuilder: (context, index) {
                            final ingredient =
                                widget
                                    .genaratedPlanModel
                                    .data!
                                    .ingredients![index];
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${ingredient.name}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
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
                      "${AppLocalizations.of(context)!.carbs}: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "~${widget.genaratedPlanModel.data?.nutritionalInfo?.carbs} ${AppLocalizations.of(context)!.perPerson}",
                    ),
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
                    "${AppLocalizations.of(context)!.noFoodWasteThesePortionAreJustRightFor} ${widget.genaratedPlanModel.data?.numberOfServings} ${AppLocalizations.of(context)!.people}.",
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
