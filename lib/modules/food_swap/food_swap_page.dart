import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/empty_list.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/food_swap/my_listings_page.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class FoodSwapPage extends StatefulWidget {
  const FoodSwapPage({super.key, required this.onBack});
  final VoidCallback onBack;
  @override
  State<FoodSwapPage> createState() => _FoodSwapPageState();
}

class _FoodSwapPageState extends State<FoodSwapPage> {
  String selectedFilter = "My Listings";
  bool isPending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyListingsPage(isEdit: false),
            ),
          );
        },
        child: Icon(Icons.add, color: AppColor.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: saverAppBar(
        "Food Swap",
        context,
        textColor: AppColor.white,
        iconColor: AppColor.white,
        iswhite: false,
        isneedtopop: true,
        onpop: widget.onBack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            SizedBox(height: 6),
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
            SizedBox(height: 20),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: _buildFilterButtons(
                    AppColor.appbarColor,
                    AppColor.lightAppbarColor,
                    "My Listings",
                  ),
                ),
                Expanded(
                  child: _buildFilterButtons(
                    AppColor.green,
                    AppColor.greenshade,
                    "Available Swaps",
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Listings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    _showFilterDialog();
                  },
                  child: Icon(Icons.filter_list),
                ),
              ],
            ),
            SizedBox(height: 20),
            swapMyList(),
          ],
        ),
      ),
    );
  }

  _buildFilterButtons(Color textcolor, Color backgroundColor, String text) {
    bool isSelected = selectedFilter == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter =
              (selectedFilter == text)
                  ? (text == "My Listings" ? "Available Swaps" : "My Listings")
                  : text;
        });
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? backgroundColor : AppColor.white,
          border: Border.all(
            color: isSelected ? textcolor : AppColor.lightGrey200,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? textcolor : AppColor.lightGrey200,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  _showFilterDialog() {
    // String? selectedOption = "option 1";
    showBottomSheet(
      backgroundColor: AppColor.white,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text("Filter by ", style: TextStyle(fontSize: 16)),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(child: Text("Locaton")),
                          ),
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(child: Text("Expiry Date")),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Column(children: [
                         
                        ],
                      )),
                  ],
                ),
              ),

              Row(
                children: [
                  _buildFilterButtons(
                    AppColor.yellow600,
                    AppColor.yellow600,
                    "Available Swaps",
                  ),
                  _buildFilterButtons(
                    AppColor.yellow600,
                    AppColor.yellow600,
                    "My Listings",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget swapMyList() {
    return StreamBuilder(
      stream: Services.getUserSwapListStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SaverLoader();
        }

        if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
            style: TextStyle(color: Colors.red),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Expanded(
            child: EmptyList(
              message: "No food swap listings available",
              subMessage: "Tap the + button to create a new listing",
            ),
          );
        }
        final items =
            snapshot.data!.docs.map((doc) {
              return Items.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();
        return Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return swapCard(item);
            },
          ),
        );
      },
    );
  }

  Widget swapCard(Items items) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyListingsPage(isEdit: true, items: items),
          ),
        );
      },
      child: Container(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(color: AppColor.lightGrey200),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(Icons.image, color: AppColor.lightGrey200),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            items.name ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 12),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColor.lightYellow,
                            ),
                            height: 27,
                            child: Center(
                              child: Text(
                                "pending",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.yellow,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColor.greenshade,
                            child: loadsvg("assets/icons/expiry.svg"),
                          ),
                          Text(
                            " Expiry Date: ${DateFormatHelper.ddmmyyyy(items.expiredDate ?? DateTime.now())}",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.lightGrey200,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IntrinsicWidth(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColor.lightblue,
                                  child: Icon(
                                    size: 14,
                                    Icons.location_on_outlined,
                                    color: AppColor.blue,
                                  ),
                                ),
                                Text(
                                  " Location: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.lightGrey200,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColor.lightRed,
                                child: Icon(
                                  size: 14,
                                  Icons.list_outlined,
                                  color: AppColor.red,
                                ),
                              ),
                              Text(
                                " Quantity: ${items.quantity}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColor.lightGrey200,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            isPending
                ? Column(
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
                      child: SizedBox(
                        width: double.infinity,
                        child: SaverOutlineButton(
                          text: "2 Requests Pending",
                          onPressed: () {},
                          borderColor: AppColor.yellow600,
                          textColor: AppColor.yellow600,
                        ),
                      ),
                    ),
                  ],
                )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
