import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/protein_plan_model.dart';
import 'package:saver_bbk_main/modules/zero_waste_cooking/zero_waste_generated_result.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

class SavedZeroWastePlansPage extends StatefulWidget {
  const SavedZeroWastePlansPage({super.key});

  @override
  State<SavedZeroWastePlansPage> createState() => _SavedZeroWastePlansPageState();
}

class _SavedZeroWastePlansPageState extends State<SavedZeroWastePlansPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
         "Saved Cooking Plans",
        context,
        isneedtopop: true,
        iswhite: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Collections.zeroWasteSavedPlans
            .where('uid', isEqualTo: Services.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SaverLoader();
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading saved plans"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
               "No Saved Plans Found",
                style: TextStyle(fontSize: 16, color: AppColor.lightGrey200),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(14),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              GenaratedProteinPlanModel model;
              try {
                model = GenaratedProteinPlanModel.fromJson(data);
              } catch (e) {
                return SizedBox(); // Skip malformed data
              }

              final recipeName = model.data?.recipeName ?? "Unknown Recipe";
              final mealType = data['selectedMeal'] ?? "Meal";
              final servings = model.data?.numberOfServings ?? 1;
              final DateTime? createdAt = data['createdAt'] != null 
                  ? (data['createdAt'] as Timestamp).toDate() 
                  : null;

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ZeroWasteRecipeResultPage(
                          genaratedPlanModel: model,
                          isForOnePerson: data['isForOnePerson'] ?? (servings == 1),
                          selectedMeal: data['selectedMeal'],
                          enteredName: data['enteredName'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.lightGrey),
                      color: AppColor.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: AppColor.lightGreen100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.restaurant_menu, color: AppColor.primaryColor, size: 30),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        recipeName,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        bool confirm = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(AppLocalizations.of(context)!.delete),
                                            content: Text("Are you sure you want to permanently delete this saved plan?"),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel", style: TextStyle(color: Colors.grey))),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true), 
                                                child: Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        ) ?? false;
                                        if (confirm) {
                                          await docs[index].reference.delete();
                                          if (mounted) {
                                            SaverSnackBar.show(context: context, message: "Plan deleted successfully", isTrue: true);
                                          }
                                        }
                                      },
                                      child: Icon(Icons.delete_outline, color: Colors.red, size: 22),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "$mealType • $servings Person(s)",
                                  style: TextStyle(color: Colors.black87, fontSize: 14),
                                ),
                                SizedBox(height: 6),
                                if (createdAt != null)
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, size: 14, color: AppColor.lightGrey200),
                                      SizedBox(width: 4),
                                      Text(
                                        "Saved on ${DateFormatHelper.ddmmyyyy(createdAt)}",
                                        style: TextStyle(color: AppColor.lightGrey200, fontSize: 12),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
