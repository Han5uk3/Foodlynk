import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/api/app_apis.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/models/protein_plan_model.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

class ZeroWasteRecipeResultPage extends StatefulWidget {
  final GenaratedProteinPlanModel genaratedPlanModel;
  final bool isForOnePerson;
  final String? enteredName;
  final String? selectedMeal;

  const ZeroWasteRecipeResultPage({
    super.key,
    required this.genaratedPlanModel,
    required this.isForOnePerson,
    this.enteredName,
    this.selectedMeal,
  });

  @override
  State<ZeroWasteRecipeResultPage> createState() =>
      _ZeroWasteRecipeResultPageState();
}

class _ZeroWasteRecipeResultPageState extends State<ZeroWasteRecipeResultPage> {
  bool isSaving = false;
  bool isShoppingListCreated = false;
  bool isCreatingShoppingList = false;

  Future<void> _savePlan() async {
    setState(() {
      isSaving = true;
    });
    try {
      final docRef = Collections.zeroWasteSavedPlans.doc();
      final map = widget.genaratedPlanModel.toJson();
      map["isForOnePerson"] = widget.isForOnePerson;
      map["enteredName"] = widget.enteredName;
      map["selectedMeal"] = widget.selectedMeal;
      map["createdAt"] = FieldValue.serverTimestamp();
      map["uid"] = Services.uid;
      map["documentId"] = docRef.id;

      await docRef.set(map);
      if (mounted) {
        SaverSnackBar.show(context: context, message: "Plan Saved Successfully!", isTrue: true);
      }
    } catch (e) {
      if (mounted) {
        SaverSnackBar.show(context: context, message: "Failed to save plan: $e", isTrue: false);
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        widget.isForOnePerson
            ? "${AppLocalizations.of(context)!.portionPlan} ${widget.enteredName != null && widget.enteredName!.isNotEmpty ? '${AppLocalizations.of(context)!.forText} ${widget.enteredName!}' : ''}"
            : AppLocalizations.of(context)!.portionPlan,
        context,
        iswhite: true,
        isneedtopop: true,
        actions: [
          IconButton(
            onPressed: isSaving ? null : _savePlan,
            icon: isSaving 
                ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryColor)) 
                : Icon(Icons.bookmark_border_rounded, color: AppColor.black, size: 28),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    final recipeName = widget.genaratedPlanModel.data?.recipeName ?? "Recipe";
    final ingredients = widget.genaratedPlanModel.data?.ingredients ?? [];
    final itemsFromKitchenRaw = widget.genaratedPlanModel.data?.itemsFromKitchen ?? [];
    final recipeSteps = widget.genaratedPlanModel.data?.steps ?? [];
    
    // Normalize kitchen items for comparison
    final itemsFromKitchen = itemsFromKitchenRaw.map((e) => e.toString().toLowerCase().trim()).toList();

    // Determine missing items
    final missingItems = ingredients.where((ingredient) {
      if (ingredient.name == null) return false;
      return !itemsFromKitchen.contains(ingredient.name!.toLowerCase().trim());
    }).toList();

    final hasProtein = widget.genaratedPlanModel.data?.nutritionalInfo?.protein != null && 
                       widget.genaratedPlanModel.data?.nutritionalInfo?.protein != "N/A" && 
                       widget.genaratedPlanModel.data?.nutritionalInfo?.protein != "null";
    final hasCarbs = widget.genaratedPlanModel.data?.nutritionalInfo?.carbs != null && 
                     widget.genaratedPlanModel.data?.nutritionalInfo?.carbs != "N/A" && 
                     widget.genaratedPlanModel.data?.nutritionalInfo?.carbs != "null";

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
            if (!widget.isForOnePerson) _buildBanner(),
            if (!widget.isForOnePerson) SizedBox(height: 10),
            if (widget.isForOnePerson &&
                widget.selectedMeal != null &&
                widget.selectedMeal!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "Meal: ${widget.selectedMeal}",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            SizedBox(height: 10),
            Text(
              "${AppLocalizations.of(context)!.recipeName}: $recipeName",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            if (hasProtein)
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
                        widget.isForOnePerson
                            ? "~${widget.genaratedPlanModel.data?.nutritionalInfo?.protein}"
                            : "~${widget.genaratedPlanModel.data?.nutritionalInfo?.protein} ${AppLocalizations.of(context)!.perPerson}",
                      ),
                    ],
                  ),
                ),
              ),
            if (hasProtein) SizedBox(height: 20),
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
                          const Spacer(),
                          Text(
                            widget.isForOnePerson
                                ? "~${widget.genaratedPlanModel.data?.nutritionalInfo?.calories}"
                                : "~${widget.genaratedPlanModel.data?.nutritionalInfo?.calories} ${AppLocalizations.of(context)!.perPerson}",
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
                        height: ingredients.length * 85,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: ingredients.length,
                          itemBuilder: (context, index) {
                            final ingredient = ingredients[index];
                            final isMissing = missingItems.contains(ingredient);
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isMissing ? Colors.red.shade300 : Colors.green.shade300,
                                  ),
                                  color: isMissing ? Colors.red.shade50 : Colors.green.shade50,
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
                                      Expanded(
                                        child: Text(
                                          "${ingredient.name} (${ingredient.quantity ?? '-'})",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(
                                        isMissing ? Icons.cancel_outlined : Icons.check_circle_outline_outlined,
                                        size: 35,
                                        color: isMissing ? Colors.red : AppColor.primaryColor,
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
            if (hasCarbs)
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
                        widget.isForOnePerson
                            ? "~${widget.genaratedPlanModel.data?.nutritionalInfo?.carbs}"
                            : "~${widget.genaratedPlanModel.data?.nutritionalInfo?.carbs} ${AppLocalizations.of(context)!.perPerson}",
                      ),
                    ],
                  ),
                ),
              ),
            if (hasCarbs) SizedBox(height: 20),
            
            if (recipeSteps.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.lightGrey200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cooking Steps", 
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                      ),
                      Divider(thickness: 2, color: Colors.grey.shade200),
                      ...recipeSteps.asMap().entries.map((entry) {
                        int idx = entry.key + 1;
                        String stepText = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("$idx. ", style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.primaryColor, fontSize: 15)),
                              Expanded(child: Text(stepText, style: TextStyle(height: 1.4, fontSize: 15, color: Colors.black87))),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            if (recipeSteps.isNotEmpty) SizedBox(height: 30),

            if (missingItems.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (isShoppingListCreated || isCreatingShoppingList)
                      ? null
                      : () async {
                          setState(() {
                            isCreatingShoppingList = true;
                          });
                          try {
                            final List<String> rawIngredients = missingItems.map((item) => "\${item.quantity ?? ''} \${item.name ?? ''}").toList();
                            final normalizedList = await AppApis().normalizeShoppingListItems(rawIngredients);
                            
                            final docRef = Collections.smartShopping.doc();
                            await docRef.set({
                              'listId': docRef.id,
                              'listName': recipeName,
                              'uid': Services.uid,
                              'createdAt': FieldValue.serverTimestamp(),
                              'items': normalizedList.map((normItem) => {
                                'id': DateTime.now().millisecondsSinceEpoch.toString() + normItem['name'].toString(),
                                'name': normItem['name'],
                                'quantity': normItem['quantity'],
                                'unit': 'Nos',
                                'item_image': '',
                                'category': normItem['category'],
                                'status': 'AL'
                              }).toList()
                            });
                            
                            if (mounted) {
                              setState(() {
                                isShoppingListCreated = true;
                              });
                              SaverSnackBar.show(
                                context: context, 
                                message: "Shopping List Created Successfully!", 
                                isTrue: true,
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              SaverSnackBar.show(
                                context: context, 
                                message: "Failed to create shopping list: $e", 
                                isTrue: false,
                              );
                            }
                          } finally {
                            if (mounted && !isShoppingListCreated) {
                              setState(() {
                                isCreatingShoppingList = false;
                              });
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isShoppingListCreated 
                        ? Colors.grey.shade400 
                        : AppColor.primaryColor,
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isCreatingShoppingList
                      ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          isShoppingListCreated 
                              ? "Shopping List Created" 
                              : "Create Smart Shopping List",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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

    Path topLeftPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.53, 0)
      ..lineTo(size.width * 0.76, size.height)
      ..lineTo(0, size.height)
      ..close();

    paint.color = Color.fromARGB(100, 246, 231, 178);
    canvas.drawPath(topLeftPath, paint);

    Path bottomRightPath = Path()
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
