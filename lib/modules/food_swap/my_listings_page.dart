import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_selector/number_selector.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/calender.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/image_picker.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';

import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key, required this.isEdit});
  final bool isEdit;
  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  DateTime selectedExpiryDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        actions:
            widget.isEdit
                ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: IconButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      icon: Icon(CupertinoIcons.trash),
                      color: AppColor.red,
                      onPressed: () {},
                    ),
                  ),
                ]
                : [],
        widget.isEdit ? "My Listing" : "Add New Item",
        context,
        isneedtopop: false,
        bottom:
            widget.isEdit
                ? PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      children: [
                        Divider(color: Colors.grey.shade200, thickness: 1),
                        SizedBox(
                          height: 40,
                          child: TabBar(
                            isScrollable: false,
                            physics: BouncingScrollPhysics(),
                            tabs: [
                              Tab(text: "Food Details"),
                              Tab(text: "Requests"),
                            ],
                            indicatorColor: AppColor.appbarColor,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            labelColor:
                                AppColor.black, // Selected tab text color
                            unselectedLabelColor:
                                Colors.grey, // Unselected tab text color
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 5,
                                color: AppColor.appbarColor,
                              ), // Customize underline
                              // Optional: Adjust width of the line
                            ),
                            controller: tabController,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: SizedBox(),
                ),
      ),
      body:
          widget.isEdit
              ? TabBarView(
                controller: tabController,
                children: [FoodDetails(isEditable: true), RequestsDetails()],
              )
              : FoodDetails(isEditable: false),
    );
  }
}

class FoodDetails extends StatefulWidget {
  const FoodDetails({super.key, required this.isEditable});
  final bool isEditable;
  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  TextEditingController nameController = TextEditingController();
  String? selectedUnit;
  int numberOfQuantity = 0;
  String selectedCategory = "";
  DateTime selectedExpiryDate = DateTime.now();
  File? _imageFile;

  List<String> unit = ["Kg", "Pcs", "ml", "Ltr", "gm", "Nos"];
  List<String> category = [
    "Dairy",
    "Meat",
    "Oils",
    "Poultry",
    "Fruits",
    "Vegetables",
    "Seafood",
  ];
  void _onDatePicked(DateTime date) {
    setState(() {
      selectedExpiryDate = date;
    });
  }

  void _setImage(File image) {
    setState(() {
      _imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: 14, left: 14, right: 14, bottom: 24),
        child: SaverButton(
          text: widget.isEditable ? "Save Changes" : "Add to Listing",
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Item Name", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SaverTextField(
              hintText: "Garlic Bread",
              controller: nameController,
            ),
            SizedBox(height: 15),
            Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IntrinsicWidth(
                  child: SaverDropdown(
                    onChanged: (value) {
                      setState(() {
                        selectedUnit = value;
                      });
                    },
                    items: unit,
                    selectedItem: selectedUnit ?? "",
                    hint: "Choose",
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: NumberSelector.plain(
                    hasBorder: true,
                    showMinMax: false,
                    min: 1,
                    iconColor: Colors.grey.shade500,
                    borderRadius: 6,
                    borderColor: Colors.grey.shade300,
                    backgroundColor: Colors.white,
                    current: numberOfQuantity,
                    onUpdate: (newValue) {
                      setState(() {
                        numberOfQuantity = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text("Expiry Date", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ShowCalendar(
              isEdit: widget.isEditable,
              restrictBackDates: true,
              initialDate: selectedExpiryDate,
              onDatePicked: _onDatePicked,
            ),
            SizedBox(height: 15),
            Text("Upload Image", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                if (_imageFile != null)
                  Stack(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: SizedBox(
                          width: 100,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _imageFile = null;
                                });
                              },
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white70,
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
                      ),
                    ],
                  ),
                _imageFile == null
                    ? ImagePickerButton(
                      isFood: false,
                      onImageSelected: _setImage,
                    )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RequestsDetails extends StatefulWidget {
  const RequestsDetails({super.key});

  @override
  _RequestsDetailsState createState() => _RequestsDetailsState();
}

class _RequestsDetailsState extends State<RequestsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                  left: 12,
                                  right: 12,
                                ),
                                child: Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    border: Border.all(
                                      color: AppColor.lightGrey200,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      color: AppColor.lightGrey200,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  spacing: 2,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Jonnathan",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 14,
                                          ),
                                          child: Icon(
                                            Icons.messenger_outline,
                                            color: AppColor.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text("Requested on 30/02/2025"),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Divider(
                                color: Colors.grey.shade200,
                                thickness: 2,
                                indent: 12,
                                endIndent: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                  bottom: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: SaverOutlineButton(
                                          text: "Accept",
                                          onPressed: () {},
                                          borderColor: AppColor.primaryColor,
                                          textColor: AppColor.primaryColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: SaverOutlineButton(
                                          text: "Decline",
                                          onPressed: () {},
                                          borderColor: AppColor.red,
                                          textColor: AppColor.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
