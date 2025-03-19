import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:number_selector/number_selector.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController itemNameController = TextEditingController();
  String selectedItem = "";
  String selectedCategory = "";

  List<String> items = ["Kg", "Pcs", "ml", "Ltr", "gm"];
  List<String> category = [
    "Dairy",
    "Meat",
    "Oils",
    "Poultry",
    "Fruits",
    "Vegetables",
    "Seafood",
  ];

  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        "Add Item",
        context,
        isneedtopop: true,
        iswhite: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Label(text: "Item Name", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              SaverTextField(
                hintText: "Enter Item Name",
                controller: itemNameController,
              ),
              SizedBox(height: 20),
              Label(text: "Quantity", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 30,
                children: [
                  IntrinsicWidth(
                    child: SaverDropdown(
                      items: items,
                      selectedItem: selectedItem,
                      hint: "Choose",
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: NumberSelector.plain(
                      hasBorder: true,
                      showMinMax: false,
                      min: 0,
                      decrementIcon: Icons.remove,
                      iconColor: Colors.black,
                      borderRadius: 6,
                      borderColor: Colors.grey.shade300,
                      backgroundColor: AppColor.white,
                      current: value,
                      onUpdate: (newValue) {
                        // Invert the logic: treat increase as decrease and vice versa
                        setState(() {
                          value = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Label(text: "Category", style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              SaverDropdown(
                items: category,
                selectedItem: selectedCategory,
                hint: "Choose",
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
