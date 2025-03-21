import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/date_compare.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/modules/kitchen_management/add_item.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class KitchenManager extends StatefulWidget {
  final VoidCallback onBack;
  const KitchenManager({super.key, required this.onBack});

  @override
  State<KitchenManager> createState() => _KitchenManagerState();
}

class _KitchenManagerState extends State<KitchenManager> {
  String selectedFilter = "";
  List<Map<String, String>> items = [
    {
      "title": "Eggs",
      "expiry": "09/03/2025",
      "category": "Poultry",
      "quantity": "5 Nos",
      "status": "E",
    },
    {
      "title": "Milk",
      "expiry": "12/03/2025",
      "category": "Dairy",
      "quantity": "1 Ltr",
      "status": "E",
    },
    {
      "title": "Apple",
      "expiry": "09/03/2025",
      "category": "Fruits",
      "quantity": "3 Nos",
      "status": "F",
    },
    {
      "title": "Chicken",
      "expiry": "23/03/2025",
      "category": "Meat",
      "quantity": "1 Kg",
      "status": "Expiring Soon",
    },
  ];
  List<Map<String, String>> shoppingList = [];
  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void addToShoppingList(Map<String, String> item) {
    setState(() {
      shoppingList.add(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item["title"]} added to shopping list')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddItem(isEdit: false)),
          );
        },
        child: Icon(Icons.add, color: AppColor.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: saverAppBar(
        'Kitchen Manager',
        textColor: AppColor.white,
        iconColor: AppColor.white,
        context,
        isneedtopop: true,
        onpop: widget.onBack,
        iswhite: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: CustomPaint(
                painter: DiagonalBackgroundPainter(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.rotate(
                            angle: -1.57,
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: CircularProgressIndicator(
                                value: 0.85,
                                strokeWidth: 8,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColor.pointColor,
                                ),
                                backgroundColor: Color.fromARGB(
                                  130,
                                  249,
                                  219,
                                  116,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "85%",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.pointColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "You've consumed 85% of your food before expiry this month!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColor.lightGrey200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColor.lightGrey200),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColor.lightGrey200),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColor.lightGrey200),
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                      ),
                      hintStyle: TextStyle(color: AppColor.lightGrey200),
                      hintText: "search items",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 5,
              children: [
                Expanded(
                  child: _buildFilterButtons(
                    AppColor.red,
                    "Expired",
                    Icons.sentiment_neutral_outlined,
                  ),
                ),
                Expanded(
                  child: _buildFilterButtons(
                    AppColor.pointColor,
                    "Expiring Soon",
                    Icons.sentiment_satisfied_alt_outlined,
                  ),
                ),
                Expanded(
                  child: _buildFilterButtons(
                    AppColor.green,
                    "Fresh",
                    Icons.sentiment_very_satisfied_outlined,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              selectedFilter.isEmpty
                  ? "All Items"
                  : selectedFilter == "Expiring Soon"
                  ? "Items $selectedFilter"
                  : "$selectedFilter Items",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.black, // Change this color as needed
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  int days = getDateDifferenceNumber(items[index]["expiry"]!);
                  int daysLeft = days.abs();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Dismissible(
                      key: Key(item["title"]! + item["expiry"]!),
                      direction: DismissDirection.horizontal,
                      background: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 12),

                          child: Row(
                            spacing: 3,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                "Move to Shopping List",
                                style: TextStyle(color: AppColor.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 12),

                        child: Row(
                          spacing: 3,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.trash,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              "Remove from list",
                              style: TextStyle(color: AppColor.white),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          addToShoppingList(item);
                        } else {
                          removeItem(index);
                        }
                      },
                      child: GestureDetector(
                        onTap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => AddItem(
                                      isEdit: true,
                                      dateString: items[index]["expiry"]!,
                                    ),
                              ),
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    border: Border.all(
                                      color: AppColor.lightGrey200,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
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
                                      children: [
                                        Text(
                                          items[index]["title"]!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            color:
                                                days < 0
                                                    ? AppColor.lightRed
                                                    : days == 0 && days < 3
                                                    ? AppColor.lightYellow
                                                    : AppColor.greenshade,
                                          ),
                                          height: 27,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 9,
                                              vertical: 3,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  days < 0
                                                      ? Icons
                                                          .sentiment_neutral_outlined
                                                      : days == 0 && days < 3
                                                      ? Icons
                                                          .sentiment_satisfied_alt_outlined
                                                      : Icons
                                                          .sentiment_very_satisfied_outlined,
                                                  size: 14,
                                                  color:
                                                      days < 0
                                                          ? AppColor.red
                                                          : days == 0 &&
                                                              days < 3
                                                          ? AppColor.yellow
                                                          : AppColor.green,
                                                ),
                                                Text(
                                                  "$daysLeft d",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        days < 0
                                                            ? AppColor.red
                                                            : days == 0 &&
                                                                days < 3
                                                            ? AppColor.yellow
                                                            : AppColor.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: AppColor.greenshade,
                                          child: loadsvg(
                                            "assets/icons/expiry.svg",
                                          ),
                                        ),
                                        Text(
                                          " Expiry Date: ${items[index]["expiry"]!}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.lightGrey200,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    AppColor.lightblue,
                                                child: Icon(
                                                  size: 14,
                                                  Icons.task_alt_outlined,
                                                  color: AppColor.blue,
                                                ),
                                              ),
                                              Text(
                                                " Category: ${items[index]["category"]!}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.lightGrey200,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    AppColor.lightRed,
                                                child: Icon(
                                                  size: 14,
                                                  Icons.list_outlined,
                                                  color: AppColor.red,
                                                ),
                                              ),
                                              Text(
                                                " Quantity: ${items[index]["quantity"]!}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.lightGrey200,
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
                            ],
                          ),
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
    );
  }

  _buildFilterButtons(Color textcolor, String text, IconData icondata) {
    bool isSelected = selectedFilter == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = selectedFilter == text ? "" : text;
        });
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? textcolor : AppColor.lightGrey200,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
          child: Row(
            spacing: 2,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icondata,
                size: 18,
                color: isSelected ? textcolor : AppColor.lightGrey200,
              ),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? textcolor : AppColor.lightGrey200,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
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
