import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/models/donation_model.dart';
import 'package:saver_bbk_main/modules/food_share/bloc/food_share_bloc.dart';
import 'package:saver_bbk_main/modules/food_share/food_share_home_page.dart';
import 'package:saver_bbk_main/modules/food_share/widgets/donnation_cards.dart';
import 'package:saver_bbk_main/modules/food_share/widgets/role_section_dialog.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodShareAllPage extends StatefulWidget {
  const FoodShareAllPage({super.key, required this.onBack});

  final VoidCallback onBack;
  @override
  State<FoodShareAllPage> createState() => _FoodShareAllPageState();
}

class _FoodShareAllPageState extends State<FoodShareAllPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int? selectedFilter;
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
            _tabController.animateTo(isDonor ? 1 : 0);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        AppLocalizations.of(context)!.foodShare,
        context,
        iswhite: false,
        textColor: AppColor.white,
        iconColor: AppColor.white,
        isneedtopop: true,
        onpop: widget.onBack,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FoodShareHomePage(
                        isDonor: _tabController.index == 0,
                      )),
            ),
            label: Label(
              text: AppLocalizations.of(context)!.myRequests,
              style: TextStyle(fontSize: 13, color: AppColor.white),
            ),
            icon: Icon(Icons.person_2, color: AppColor.white),
          ),
        ],
      ),
      body: _buildBody(),
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
          return Center(
            child: Text(AppLocalizations.of(context)!.noDonationsFound),
          );
        }

        return ListView.separated(
          itemCount: donerList?.length ?? 0,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final donation = donerList![index];
            return DonnationCards(
              isBenificiary: false,
              item: donation,
              isDonor: _tabController.index == 0,
              itsMy: false,
              isFromHomePage: true,
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
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final beneficiaryList = snapshot.data;
        if (beneficiaryList?.isEmpty ?? false) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noBenificiaryFound),
          );
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
              isDonor: _tabController.index == 1,
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
          _tabController.index == 0
              ? AppLocalizations.of(context)!.globalDonations
              : AppLocalizations.of(context)!.availableFood,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
