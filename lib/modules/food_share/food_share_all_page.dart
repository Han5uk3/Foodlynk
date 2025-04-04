import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/models/donation_model.dart';
import 'package:saver_bbk_main/modules/food_share/bloc/food_share_bloc.dart';
import 'package:saver_bbk_main/modules/food_share/food_share_home_page.dart';
import 'package:saver_bbk_main/modules/food_share/widgets/donnation_cards.dart';
import 'package:saver_bbk_main/modules/food_share/widgets/role_section_dialog.dart';
import 'package:saver_bbk_main/services/app_services.dart';
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
  bool _hasShownRoleDialog = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasShownRoleDialog) {
        _showRoleSelectionDialog();
        _hasShownRoleDialog = true;
      }
    });
    super.initState();
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

  void _showRoleSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return RoleSelectionDialog(
          onRoleSelected: (isDonor) {
            setState(() {
              _tabController.animateTo(isDonor ? 0 : 1);
            });
          },
        );
      },
    );
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
        actions: [
          TextButton.icon(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodShareHomePage()),
                ),
            label: Label(
              text: "My Requests",
              style: TextStyle(fontSize: 13, color: AppColor.white),
            ),
            icon: Icon(Icons.person_2, color: AppColor.white),
          ),
        ],
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
                                            fillColor: MaterialStatePropertyAll(
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
                                            fillColor: MaterialStatePropertyAll(
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          SizedBox(height: 15),
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
        children: [_buildDonationsTab(), _buildBeneficiaryTab()],
      ),
    );
  }

  Widget _buildDonationsTab() {
    return StreamBuilder<List<DonationModel>>(
      stream: Services.getGlobalDonations("DONR"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SaverLoader();
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final donerList = snapshot.data;
        if (donerList?.isEmpty ?? false) {
          return Center(child: Text("No donations available."));
        }

        return ListView.separated(
          itemCount: donerList?.length ?? 0,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final donation = donerList![index];
            return DonnationCards(
              isBenificiary: false,
              item: donation,
              tabIndex: _tabController.index,
              itsMy: false,
              onInterestToggled: (isIntrested, id, type) {
                context.read<FoodShareBloc>().add(
                  IntrestedFoodShareEvent(
                    id: id,
                    type: type,
                    isInterested: true,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBeneficiaryTab() {
    return StreamBuilder<List<DonationModel>>(
      stream: Services.getGlobalDonations("BENF"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SaverLoader();
        }
        if (snapshot.hasError) {
          log(snapshot.error.toString());
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final beneficiaryList = snapshot.data;
        if (beneficiaryList?.isEmpty ?? false) {
          return Center(child: Text("No beneficiaries available."));
        }
        return ListView.separated(
          itemCount: beneficiaryList?.length ?? 0,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final beneficiary = beneficiaryList![index];
            return DonnationCards(
              itsMy: false,
              isBenificiary: true,
              item: beneficiary,
              tabIndex: _tabController.index,
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _tabController.index == 0 ? "Global Donations" : "Available Food",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: _showFilterDialog,
          child: Icon(Icons.filter_list),
        ),
      ],
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
