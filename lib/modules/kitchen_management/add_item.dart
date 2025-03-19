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
  List<String> items = ["Kg", "Pcs", "ml", "Ltr", "gm"];
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
              Label(text: "Item Name", style: TextStyle(fontSize: 16)),
              SaverTextField(
                hintText: "Enter Item Name",
                controller: itemNameController,
              ),
              Label(text: "Quantity", style: TextStyle(fontSize: 16)),
              Row(
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
                      borderRadius: 6,
                      borderColor: Colors.grey.shade300,
                      backgroundColor: AppColor.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
