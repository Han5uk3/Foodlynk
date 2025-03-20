import 'dart:io';

import 'package:flutter/material.dart';
import 'package:number_selector/number_selector.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/image_picker.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key, required this.isEdit});

  final bool isEdit;
  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController itemNameController = TextEditingController();
  String selectedItem = "";
  String selectedCategory = "";
  String date = "DD/MM/YYYY";
  DateTime initialDate = DateTime.now();

  List<String> items = ["Kg", "Pcs", "ml", "Ltr", "gm", "Nos"];
  List<String> category = [
    "Dairy",
    "Meat",
    "Oils",
    "Poultry",
    "Fruits",
    "Vegetables",
    "Seafood",
  ];
  File? _imageFile;

  void _setImage(File image) {
    setState(() {
      _imageFile = image;
    });
  }

  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child:
            widget.isEdit
                ? Row(
                  children: [
                    SaverButton(
                      text: "Move to Shopping List",
                      onPressed: () {},
                    ),
                    SaverButton(
                      text: "Remove from list",
                      onPressed: () {},
                      color: AppColor.red,
                    ),
                  ],
                )
                : SaverButton(text: "Add Item", onPressed: () {}),
      ),
      appBar: saverAppBar(
        widget.isEdit ? "Edit Item" : "Add Item",
        context,
        isneedtopop: true,
        iswhite: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(text: "Item Name", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      SaverTextField(
                        toggle: !widget.isEdit,
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
                              onChanged:
                                  widget.isEdit
                                      ? (value) {
                                        null;
                                      }
                                      : (value) {
                                        setState(() {
                                          selectedItem = value!;
                                        });
                                      },
                            ),
                          ),
                          Expanded(
                            child: NumberSelector.plain(
                              enabled: !widget.isEdit,
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
                      SizedBox(height: 20),
                      Label(
                        text: "Expiry Date",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                date,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    widget.isEdit
                                        ? null
                                        : () async {
                                          DateTime?
                                          pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: initialDate,
                                            firstDate: DateTime(2000),
                                            barrierDismissible: false,
                                            lastDate: DateTime(2100),
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(
                                                  context,
                                                ).copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                        primary: AppColor.green,
                                                        surface: AppColor.white,
                                                      ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );

                                          if (pickedDate != null) {
                                            setState(() {
                                              date =
                                                  "${pickedDate.day.toString()}/${pickedDate.month.toString()}/${pickedDate.year.toString()}";
                                              initialDate = pickedDate;
                                            });
                                          }
                                        },
                                icon: Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColor.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Label(
                        text: "Upload Image",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Row(
                          children: [
                            if (_imageFile != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: IntrinsicWidth(
                                  child: IntrinsicHeight(
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Center(
                                            child: Container(
                                              height: 90,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: FileImage(_imageFile!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Positioned(
                                            child: GestureDetector(
                                              onTap:
                                                  widget.isEdit
                                                      ? null
                                                      : () {
                                                        setState(() {
                                                          _imageFile = null;
                                                        });
                                                      },
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.white,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: AppColor.black,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            _imageFile == null
                                ? widget.isEdit
                                    ? SizedBox()
                                    : ImagePickerButton(
                                      onImageSelected: _setImage,
                                    )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
