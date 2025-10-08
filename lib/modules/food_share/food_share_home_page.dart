import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/models/donation_model.dart';
import 'package:saver_bbk_main/modules/food_share/donation_details.dart';
import 'package:saver_bbk_main/modules/food_share/widgets/donnation_cards.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

class FoodShareHomePage extends StatefulWidget {
  final bool isDonor;
  const FoodShareHomePage({super.key, required this.isDonor});

  @override
  State<FoodShareHomePage> createState() => _FoodShareHomePageState();
}

class _FoodShareHomePageState extends State<FoodShareHomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        AppLocalizations.of(context)!.myDonationsRequests,
        context,
        iswhite: true,
        isneedtopop: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DonationDetails(
                isDonor: !widget.isDonor,
                isView: false,
                isFromCard: false,
                model: DonationModel(),
              ),
            )),
        child: Icon(Icons.add, color: AppColor.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: _buildTabContent(),
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child:
          widget.isDonor ? _buildRecievedTab(false) : _buildDonationsTab(true),
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
              isDonor: widget.isDonor,
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
              isDonor: widget.isDonor,
              isBenificiary: true,
              itsMy: true,
            );
          },
        );
      },
    );
  }
}
