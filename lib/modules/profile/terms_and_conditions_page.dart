import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        AppLocalizations.of(context)!.termsAndConditions,
        context,
        isneedtopop: true,
        iswhite: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.justify,
                style: TextStyle(color: AppColor.lightGrey200, fontSize: 14),
                AppLocalizations.of(context)!.welcomeToSAverApp,
              ),
              _buildtermscontent(
                "1. ${AppLocalizations.of(context)!.acceptanceOfTerms}",
                AppLocalizations.of(context)!.byDownloading,
              ),
              _buildtermscontent(
                "2.  ${AppLocalizations.of(context)!.descriptionOfServices}",
                AppLocalizations.of(context)!.saverAppOffersAVariety,
              ),
              _buildtermscontent(
                "3. ${AppLocalizations.of(context)!.userResponsibilities}",
                AppLocalizations.of(context)!.usersAreResponsibleForEnsuring,
              ),
              _buildtermscontent(
                "4. ${AppLocalizations.of(context)!.virtualRewards}",
                AppLocalizations.of(context)!.coinsEarnedThroughChallenges,
              ),
              _buildtermscontent(
                "5. ${AppLocalizations.of(context)!.intellectualProperty}",
                AppLocalizations.of(context)!.allDesignElements,
              ),
              _buildtermscontent(
                "6. ${AppLocalizations.of(context)!.privacy}",
                AppLocalizations.of(context)!.saverAppIsCommittedTo,
              ),
              _buildtermscontent(
                "7.${AppLocalizations.of(context)!.modificationsToTerms}",
                AppLocalizations.of(context)!.saverAppMayUpadte,
              ),
              _buildtermscontent(
                "8. ${AppLocalizations.of(context)!.limitationOfLiability}",
                AppLocalizations.of(context)!.theAppIsProvidedAsIs,
              ),
              _buildtermscontent(
                "9. ${AppLocalizations.of(context)!.termination}",
                AppLocalizations.of(context)!.weReserveTheRightTo,
              ),
              _buildtermscontent(
                "10. ${AppLocalizations.of(context)!.contactUs}",
                AppLocalizations.of(context)!.ifYouHaveAnyQuestions,
              ),
              SizedBox(height: 12),
              Text(
                "${AppLocalizations.of(context)!.email}: niema.kw@gmail.com",
                style: TextStyle(color: AppColor.lightGrey200, fontSize: 14),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  _buildtermscontent(head, desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Label(text: head, isBold: true),
        SizedBox(height: 20),
        Text(
          textAlign: TextAlign.justify,
          style: TextStyle(color: AppColor.lightGrey200, fontSize: 14),
          desc,
        ),
      ],
    );
  }
}
