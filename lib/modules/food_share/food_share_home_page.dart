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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodShareHomePage extends StatefulWidget {
  const FoodShareHomePage({super.key});

  @override
  State<FoodShareHomePage> createState() => _FoodShareHomePageState();
}

class _FoodShareHomePageState extends State<FoodShareHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? selectedFilter;
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
        AppLocalizations.of(context)!.myDonationsRequests,
        context,
        iswhite: true,

        isneedtopop: true,
      ),
      body: _buildBody(),
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
                      Text(
                        AppLocalizations.of(context)!.newText,
                        style: TextStyle(fontSize: 18),
                      ),
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
                  child: Text(
                    AppLocalizations.of(context)!.chooseRole,
                    style: TextStyle(fontSize: 18),
                  ),
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
                          text: AppLocalizations.of(context)!.donor,
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
                          text: AppLocalizations.of(context)!.beneficiary,
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
                    text: AppLocalizations.of(context)!.continueText,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                               DonationDetails(
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
          SizedBox(height: 8),
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
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noDonationsFound),
          );
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
              isFromHomePage: false,
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
          return Center(
            child: Text(AppLocalizations.of(context)!.noBenificiaryFound),
          );
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
              AppLocalizations.of(context)!.donor,
              AppColor.appbarColor,
              AppColor.lightAppbarColor,
              0,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              AppLocalizations.of(context)!.beneficiary,
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
          _tabController.index == 0
              ? AppLocalizations.of(context)!.donor
              : AppLocalizations.of(context)!.beneficiary,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
