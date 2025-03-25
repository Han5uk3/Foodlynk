import 'package:flutter/material.dart';
import 'package:number_selector/number_selector.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class ZeroWasteCookingPage extends StatefulWidget {
  const ZeroWasteCookingPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<ZeroWasteCookingPage> createState() => _ZeroWasteCookingPageState();
}

class _ZeroWasteCookingPageState extends State<ZeroWasteCookingPage> {
  int numberOfPeople = 1;
  List<String> options = ["Breakfast", "Lunch", "Dinner", "Snack"];
  List<String> meal = ["Daily Meal", "Family Gathering", "Party"];
  int? selectedType;
  int? selectedMeal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        "Zero Waste Cooking",
        context,
        isneedtopop: true,
        iconColor: AppColor.white,
        textColor: AppColor.white,
        iswhite: false,
        onpop: widget.onBack,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                "Cook Smart, Reduce Waste!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              "Cook what just enough for your needs — no more, no less.",
              style: TextStyle(color: Colors.grey.shade500),
            ),
            SizedBox(height: 15),
            Divider(color: Colors.grey.shade200, thickness: 2),
            SizedBox(height: 15),
            Text("What are you cooking?", style: TextStyle(fontSize: 16)),
            IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(4, (index) {
                  return ListTile(
                    title: Text(
                      options[index],
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    trailing: Radio<int>(
                      value: index,
                      activeColor: AppColor.primaryColor,
                      groupValue: selectedType,
                      onChanged: (int? value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),

            Text("To Whom are you cooking?", style: TextStyle(fontSize: 16)),
            IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  return ListTile(
                    title: Text(
                      meal[index],
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    trailing: Radio<int>(
                      value: index,
                      activeColor: AppColor.primaryColor,
                      groupValue: selectedMeal,
                      onChanged: (int? value) {
                        setState(() {
                          selectedMeal = value;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
            Text("How many people are eating?", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: NumberSelector.plain(
                    hasBorder: true,
                    showMinMax: false,
                    min: 1,
                    iconColor: Colors.grey.shade500,
                    borderRadius: 6,
                    borderColor: Colors.grey.shade300,
                    backgroundColor: AppColor.white,
                    current: numberOfPeople,
                    onUpdate: (newValue) {
                      setState(() {
                        numberOfPeople = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
