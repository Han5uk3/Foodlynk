import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:number_selector/number_selector.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/modules/kitchen_management/add_item.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key, required this.name});
  final String name;
  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int quantity = 0;
  List<Map<String, String>> listItems = [
    {"name": "Mushroom", "quantity": "2 nos", "status": "true"},
    {"name": "Mutton", "quantity": "1 Kg", "status": "false"},
    {"name": "Onion", "quantity": "2 Kg", "status": "false"},
    {"name": "Tomato", "quantity": "1 Kg", "status": "false"},
    {"name": "Fish", "quantity": "2 Kg", "status": "false"},
    {"name": "Eggs", "quantity": "20 nos", "status": "false"},
    {"name": "Olive Oil", "quantity": "1 Ltr", "status": "false"},
    {"name": "Curd", "quantity": "200 gms", "status": "false"},
  ];
  List<String> unit = ["Kg", "Pcs", "ml", "Ltr", "gm", "Nos"];
  TextEditingController listNameController = TextEditingController();
  String? selectedUnit = "";
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          _showEditBottomSheet(true, false);
        },
        child: Icon(Icons.add, color: AppColor.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: saverAppBar(
        widget.name,
        context,
        isneedtopop: true,
        iswhite: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () {
              _showEditBottomSheet(false, false);
            },
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(14), child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [_buildTabSelector(), SizedBox(height: 20), _buildTabContent()],
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child: IndexedStack(
        index: _tabController.index,
        children: [_buildAllListItems(), _buildPurchasedListItems()],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              "All",
              AppColor.yellow600,
              AppColor.lightYellow,
              0,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              "Purchased",
              AppColor.primaryColor,
              AppColor.lightGreen100,
              1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    String text,
    Color textColor,
    Color backgroundColor,
    int index,
  ) {
    bool isSelected = _tabController.index == index;

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Container(
        height: 45,
        margin: EdgeInsets.only(right: index == 0 ? 5 : 0),
        decoration: BoxDecoration(
          color: isSelected ? backgroundColor : AppColor.white,
          border: Border.all(
            color: isSelected ? textColor : AppColor.lightGrey200,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? textColor : AppColor.lightGrey200,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllListItems() {
    return ListView.builder(
      itemCount: listItems.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (listItems[index]["status"] == "true") {
          return SizedBox(height: 0);
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GestureDetector(
            onTap: () {
              _showEditBottomSheet(true, true);
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.lightGrey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(fontWeight: FontWeight.w700),
                        text: listItems[index]["name"],
                        children: [
                          WidgetSpan(
                            child: Transform.translate(
                              offset: Offset(0, -5),
                              child: Text(
                                ' x${listItems[index]["quantity"]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.lightGrey200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Icon(
                      Icons.drag_indicator_outlined,
                      color: AppColor.lightGrey200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPurchasedListItems() {
    return ListView.builder(
      itemCount: listItems.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (listItems[index]["status"] == "false") {
          return SizedBox(height: 0);
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GestureDetector(
            onTap: () {
              _showEditBottomSheet(true, true);
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.lightGrey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(fontWeight: FontWeight.w700),
                        text: listItems[index]["name"],
                        children: [
                          WidgetSpan(
                            child: Transform.translate(
                              offset: Offset(0, -5),
                              child: Text(
                                ' x${listItems[index]["quantity"]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.lightGrey200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Icon(
                      Icons.check_circle_outline_outlined,
                      color: AppColor.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _showEditBottomSheet(bool isItem, bool isView) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      isDismissible: false,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isItem
                                ? isView
                                    ? "Mushroom"
                                    : "Add New Item"
                                : "Edit Shopping List",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColor.lightGrey,
                      thickness: 1.5,
                      height: 1.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 14,
                        top: 14,
                      ),
                      child: Text(
                        isItem ? "Item Name" : "List Name",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: isView,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 14,
                          right: 14,
                          top: 8,
                        ),
                        child: SaverTextField(
                          hintText:
                              isItem
                                  ? isView
                                      ? "Mushroom"
                                      : "Enter Item Name"
                                  : "Weekly Grocery",
                          controller: listNameController,
                        ),
                      ),
                    ),
                    isItem
                        ? Padding(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 14,
                            top: 14,
                          ),
                          child: Text(
                            "Quantity",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                        : SizedBox.shrink(),
                    isItem
                        ? IgnorePointer(
                          ignoring: isView,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 14,
                              right: 14,
                              top: 8,
                            ),
                            child: Row(
                              spacing: 30,
                              children: [
                                IntrinsicWidth(
                                  child: SaverDropdown(
                                    items: unit,
                                    selectedItem: selectedUnit ?? "",
                                    hint: "Choose",
                                    onChanged: (value) {
                                      setState(() {
                                        selectedUnit = value;
                                      });
                                      log("New selected unit: $selectedUnit");
                                    },
                                  ),
                                ),

                                Expanded(
                                  child: NumberSelector.plain(
                                    hasBorder: true,
                                    showMinMax: false,
                                    min: 1,
                                    iconColor: Colors.grey.shade500,
                                    borderRadius: 6,
                                    borderColor: Colors.grey.shade300,
                                    backgroundColor: AppColor.white,
                                    current: quantity,
                                    onUpdate: (newValue) {
                                      setState(() {
                                        quantity = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
                    isView
                        ? Padding(
                          padding: const EdgeInsets.only(
                            top: 14,
                            left: 14,
                            right: 14,
                          ),
                          child: Text(
                            maxLines: 2,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            "Note: When an item is Purchased, it will be moved to kitchen manager for tracking!",
                            style: TextStyle(color: AppColor.primaryColor),
                          ),
                        )
                        : SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        bottom: 24,
                        left: 14,
                        right: 14,
                      ),
                      child:
                          isItem
                              ? isView
                                  ? Row(
                                    children: [
                                      Expanded(
                                        child: SaverButton(
                                          text: "Purchased",
                                          onPressed: () {
                                            // purchased item implementation
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        AddItem(isEdit: false),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: SaverButton(
                                          text: "Remove from List",
                                          onPressed: () {
                                            // remove from shopping list implementation
                                          },
                                          color: AppColor.red,
                                        ),
                                      ),
                                    ],
                                  )
                                  : SaverButton(
                                    text: "Add Item",
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                              : SaverButton(
                                text: "Save Changes",
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
