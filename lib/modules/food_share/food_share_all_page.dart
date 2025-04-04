import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/modules/food_share/donation_details.dart';
import 'package:saver_bbk_main/modules/food_share/food_share_home_page.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class FoodShareAllPage extends StatefulWidget {
  const FoodShareAllPage({super.key, required this.onBack});

  final VoidCallback onBack;
  @override
  State<FoodShareAllPage> createState() => _FoodShareAllPageState();
}

class _FoodShareAllPageState extends State<FoodShareAllPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> filterOptions = [
    "1 to 5",
    "5 to 20",
    "20 to 50",
    "More than 50",
  ];
  List<String> filterDateOptions = [
    "Today",
    "Last 3 days",
    "Last 1 week",
    "More than a week ago",
  ];

  int? selectedFilter;
  bool _isLocationSelected = false;
  bool _isExpireDateSelected = false;

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
      appBar: saverAppBar(
        "Food Share",
        context,
        iswhite: false,
        textColor: AppColor.white,
        iconColor: AppColor.white,
        isneedtopop: true,
        onpop: widget.onBack,
      ),
      body: _buildBody(),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true, // Allows the sheet to be taller
      backgroundColor: AppColor.white,
      builder: (context) {
        return StatefulBuilder(
          // Allows state updates within the bottom sheet
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "Filter by ",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isLocationSelected = !_isLocationSelected;
                                    _isExpireDateSelected = false;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 40,

                                  width: double.infinity,
                                  decoration: BoxDecoration(),
                                  child:
                                      _isLocationSelected
                                          ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 5,
                                                color: AppColor.primaryColor,
                                              ),

                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 9,
                                                      ),
                                                  child: Text("Serves"),
                                                ),
                                              ),
                                            ],
                                          )
                                          : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 12,
                                                      ),
                                                  child: Text("Serves"),
                                                ),
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExpireDateSelected =
                                        !_isExpireDateSelected;
                                    _isLocationSelected = false;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 40,

                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                  child:
                                      _isExpireDateSelected
                                          ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 5,
                                                color: AppColor.primaryColor,
                                              ),

                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 9,
                                                      ),
                                                  child: Text("Period"),
                                                ),
                                              ),
                                            ],
                                          )
                                          : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 12,
                                                      ),
                                                  child: Text("Period"),
                                                ),
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child:
                              _isLocationSelected
                                  ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(4, (index) {
                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              // Now state updates correctly
                                              selectedFilter = index;
                                            });
                                          },
                                          title: Text(
                                            filterOptions[index],
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Radio<int>(
                                            value: index,
                                            activeColor: AppColor.primaryColor,
                                            groupValue: selectedFilter,
                                            fillColor: WidgetStateProperty.all(
                                              AppColor.primaryColor,
                                            ),
                                            onChanged: (int? value) {
                                              setState(() {
                                                selectedFilter = value!;
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                  : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(4, (index) {
                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              // Now state updates correctly
                                              selectedFilter = index;
                                            });
                                          },
                                          title: Text(
                                            filterDateOptions[index],
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Radio<int>(
                                            value: index,
                                            activeColor: AppColor.primaryColor,
                                            groupValue: selectedFilter,
                                            fillColor: WidgetStateProperty.all(
                                              AppColor.primaryColor,
                                            ),
                                            onChanged: (int? value) {
                                              setState(() {
                                                selectedFilter = value!;
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SaverOutlineButton(
                          text: "Clear All",
                          onPressed: () {
                            setState(() {
                              _isExpireDateSelected = false;
                              _isLocationSelected = false;
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: SaverButton(
                          text: "Apply",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _showRoleBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        bool isDonor = true;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("New", style: TextStyle(fontSize: 18)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close, color: AppColor.black),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade300, thickness: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text("Choose Role", style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: SaverOutlineButton(
                          textColor:
                              isDonor
                                  ? AppColor.primaryColor
                                  : AppColor.lightGrey200,
                          text: "Donor",
                          borderColor:
                              isDonor
                                  ? AppColor.primaryColor
                                  : AppColor.lightGrey,
                          onPressed: () {
                            setState(() {
                              isDonor = !isDonor;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: SaverOutlineButton(
                          borderColor:
                              isDonor
                                  ? AppColor.lightGrey
                                  : AppColor.primaryColor,
                          text: "Beneficiary",
                          textColor:
                              isDonor
                                  ? AppColor.lightGrey200
                                  : AppColor.primaryColor,
                          onPressed: () {
                            setState(() {
                              isDonor = !isDonor;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: SaverButton(
                    text: "Continue",
                    onPressed: () {
                      log("Role: ${isDonor ? "Donor" : "Beneficiary"}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DonationDetails(
                                isDonor: isDonor,
                                isView: false,
                              ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 22),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          SizedBox(height: 6),
          _buildBanner(),
          SizedBox(height: 20),
          _buildTabSelector(),
          SizedBox(height: 20),
          _buildSectionHeader(),
          SizedBox(height: 20),
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child: IndexedStack(
        index: _tabController.index,
        children: [_buildDonationsTab(true), _buildRecievedTab(false)],
      ),
    );
  }

  _buildDonationsTab(bool isDonor) {
    return ListView.separated(
      itemCount: 3,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        return donationCard("P", isDonor);
      },
    );
  }

  _buildRecievedTab(bool isDonor) {
    return ListView.separated(
      itemCount: 2,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        return donationCard("R", isDonor);
      },
    );
  }

  donationCard(String status, bool isDonor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DonationDetails(isDonor: isDonor, isView: true),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,

                          children: [
                            Expanded(
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                "dfggggggxxftfdxgzdfgzzfgdfzghfghdrxfbgxghtnhdg",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
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
                                color:
                                    status == "P"
                                        ? AppColor.lightYellow
                                        : AppColor.lightGreen,
                              ),
                              height: 27,
                              child: Center(
                                child:
                                    status == "P"
                                        ? Text(
                                          "pending",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.yellow,
                                          ),
                                        )
                                        : Text(
                                          "Picked",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.primaryColor,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        _tabController.index == 0
                            ? _buildDonatedDateRow()
                            : _buildReceivedOnDateRow(),
                        SizedBox(height: 5),
                        _tabController.index == 0
                            ? _buildServesRow()
                            : _buildDonatedByRow(),
                      ],
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

  Widget _buildDonatedDateRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.greenshade,
          child: loadsvg("assets/icons/expiry.svg"),
        ),
        Text(
          " Donated On: ${DateFormatHelper.ddmmyyyy(DateTime.now())}",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
      ],
    );
  }

  Widget _buildReceivedOnDateRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.greenshade,
          child: loadsvg("assets/icons/expiry.svg"),
        ),
        Text(
          " Recieved On: ${DateFormatHelper.ddmmyyyy(DateTime.now())}",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
      ],
    );
  }

  Widget _buildServesRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.lightblue,
          child: Icon(Icons.group_outlined, size: 14, color: AppColor.blue),
        ),
        Text(
          " Serves: 2",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
      ],
    );
  }

  Widget _buildDonatedByRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.lightblue,
          child: Icon(
            Icons.person_outline_outlined,
            size: 14,
            color: AppColor.blue,
          ),
        ),
        Text(
          " Donated By: 2",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
      ],
    );
  }

  _buildBanner() {
    return GestureDetector(
      onTap:
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FoodShareHomePage();
              },
            ),
          ),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 2,
        child: CustomPaint(
          painter: DiagonalBackgroundPainter(),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            height: 100,
            child: Text(
              "My Donations & Requests",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              "Donor",
              AppColor.appbarColor,
              AppColor.lightAppbarColor,
              0,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              "Beneficiary",
              AppColor.green500,
              AppColor.lightGreen100,
              1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _tabController.index == 0 ? "Donor" : "Beneficiary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: _showFilterDialog,
          child: Icon(Icons.filter_list),
        ),
      ],
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

    paint.color = Color(0xFFC9F5FF);
    canvas.drawPath(topLeftPath, paint);

    Path bottomRightPath =
        Path()
          ..moveTo(size.width, 0)
          ..lineTo(size.width * 0.53, 0)
          ..lineTo(size.width * 0.76, size.height)
          ..lineTo(size.width, size.height)
          ..close();

    paint.color = Color(0xFF9EE9FA);
    canvas.drawPath(bottomRightPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
