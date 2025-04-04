import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/models/donation_model.dart';
import 'package:saver_bbk_main/modules/food_share/donation_details.dart';
import 'package:saver_bbk_main/modules/food_share/widgets/donnation_cards.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class FoodShareHomePage extends StatefulWidget {
  const FoodShareHomePage({super.key});

  @override
  State<FoodShareHomePage> createState() => _FoodShareHomePageState();
}

class _FoodShareHomePageState extends State<FoodShareHomePage>
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
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          _showRoleBottomSheet();
        },
        child: Icon(Icons.add, color: AppColor.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: saverAppBar(
        "My Donations & Requests",
        context,
        iswhite: true,

        isneedtopop: true,
      ),
      body: _buildBody(),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.white,
      builder: (context) {
        return StatefulBuilder(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DonationDetails(
                                isDonor: isDonor,
                                isView: false,
                                isFromCard: false,
                                model: DonationModel(),
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
    return StreamBuilder<List<DonationModel>>(
      stream: Services.getMyDonations('DONR'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SaverLoader();
        }
        log(snapshot.hasError.toString());
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(child: Text("No Donations found"));
        }
        final donations = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(5),
          itemCount: donations.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final donation = donations[index];
            return DonnationCards(
              item: donation,
              tabIndex: _tabController.index,
              isBenificiary: false,
              itsMy: true,
            );
          },
        );
      },
    );
  }

  _buildRecievedTab(bool isDonor) {
    return StreamBuilder<List<DonationModel>>(
      stream: Services.getMyDonations('BENF'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SaverLoader();
        }
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(child: Text("No Benificiary found"));
        }
        final benificiary = snapshot.data!;

        return ListView.separated(
          itemCount: benificiary.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final donation = benificiary[index];
            return DonnationCards(
              item: donation,
              tabIndex: _tabController.index,
              isBenificiary: true,
              itsMy: true,
            );
          },
        );
      },
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
