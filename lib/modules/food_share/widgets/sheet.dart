import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/donation_model.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/modules/food_share/bloc/food_share_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodShareDetailBottomSheet extends StatelessWidget {
  final DonationModel item;
  final bool isBenificiary;
  final bool itsMy;
  final Function(bool, String, String)? onInterestToggled;

  const FoodShareDetailBottomSheet({
    super.key,
    required this.item,
    required this.isBenificiary,
    required this.itsMy,
    this.onInterestToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isBenificiary || item.image!.isEmpty)
                    _buildImageSection(),
                  SizedBox(height: 16),
                  _buildInfoSection(context),
                  SizedBox(height: 16),
                  _buildDescriptionSection(context),
                  SizedBox(height: 16),
                  _buildAddressSection(context),
                  if (!itsMy) ...[
                    SizedBox(height: 16),
                    _buildInterestButton(context),
                  ],
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              isBenificiary
                  ? AppLocalizations.of(context)!.beneficiary
                  : AppLocalizations.of(context)!.donationDetails,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: item.image ?? "",
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Container(
                color: AppColor.greenshade.withOpacity(0.3),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    color: AppColor.primaryColor.withOpacity(0.5),
                    size: 48,
                  ),
                ),
              ),
          errorWidget:
              (context, url, error) => Container(
                color: AppColor.greenshade.withOpacity(0.3),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    color: AppColor.primaryColor.withOpacity(0.5),
                    size: 48,
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                isBenificiary
                    ? item.foodType ?? "General"
                    : item.foodName ?? "Food Item",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildStatusBadge(context),
          ],
        ),
        SizedBox(height: 16),

        _buildInfoRow(
          icon: "assets/icons/expiry.svg",
          iconBgColor: AppColor.greenshade,
          text:
              isBenificiary
                  ? "${AppLocalizations.of(context)!.receivedOn} ${DateFormatHelper.ddmmyyyy(item.createdAt ?? DateTime.now())}"
                  : "${AppLocalizations.of(context)!.donatedOn} ${DateFormatHelper.ddmmyyyy(item.createdAt ?? DateTime.now())}",
        ),
        SizedBox(height: 12),

        _buildInfoRow(
          icon: null,
          iconData:
              isBenificiary
                  ? Icons.person_outline_outlined
                  : Icons.group_outlined,
          iconBgColor: AppColor.lightblue,
          iconColor: AppColor.blue,
          text:
              isBenificiary
                  ? "Donated By: ${item.contactName ?? "Anonymous"}"
                  : "${AppLocalizations.of(context)!.serves} ${item.noOfServe ?? 0}",
        ),

        if (item.expiredDate != null) ...[
          SizedBox(height: 12),
          _buildInfoRow(
            icon: "assets/icons/expiry.svg",
            iconBgColor: Colors.red.withOpacity(0.2),
            text:
                "${AppLocalizations.of(context)!.expiresOn} ${DateFormatHelper.ddmmyyyy(item.expiredDate!)}",
            textColor: Colors.red,
          ),
        ],

        if (item.contactName != null && item.contactName!.isNotEmpty) ...[
          SizedBox(height: 12),
          _buildInfoRow(
            icon: null,
            iconData: Icons.phone_outlined,
            iconBgColor: Colors.amber.withOpacity(0.2),
            iconColor: Colors.orange,
            text:
                "${AppLocalizations.of(context)!.contact} ${item.contactName ?? ""} ${item.contactMobile != null ? '(${item.contactContryCode ?? ""}${item.contactMobile})' : ''}",
          ),
        ],
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    if (item.discription == null || item.discription!.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.description,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          item.discription ?? "",
          style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    if (item.pickUpLocation == null || item.pickUpLocation!.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.pickupLocation,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        _buildInfoRow(
          icon: null,
          iconData: Icons.location_on_outlined,
          iconBgColor: AppColor.lightGreen,
          iconColor: AppColor.primaryColor,
          text: item.pickUpLocation ?? "",
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    String? icon,
    IconData? iconData,
    required Color iconBgColor,
    Color? iconColor,
    required String text,
    Color? textColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: iconBgColor,
          child:
              icon != null
                  ? loadsvg(icon)
                  : Icon(iconData, size: 16, color: iconColor),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? AppColor.lightGrey200,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final bool isPending = item.status == "P";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isPending ? AppColor.lightYellow : AppColor.lightGreen,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPending ? Icons.schedule : Icons.check_circle_outline,
            size: 14,
            color: isPending ? AppColor.yellow : AppColor.primaryColor,
          ),
          SizedBox(width: 4),
          Text(
            isPending
                ? AppLocalizations.of(context)!.pending
                : AppLocalizations.of(context)!.picked,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isPending ? AppColor.yellow : AppColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestButton(BuildContext context) {
    final bool isInterested = item.isUserInterested;

    return BlocBuilder<FoodShareBloc, FoodShareState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed:
                isInterested
                    ? null
                    : () {
                      if (onInterestToggled != null) {
                        onInterestToggled!(
                          true,
                          item.id ?? "",
                          item.type ?? "",
                        );
                      } else {
                        context.read<FoodShareBloc>().add(
                          IntrestedFoodShareEvent(
                            id: item.id ?? "",
                            type: item.type ?? "",
                            isInterested: true,
                          ),
                        );
                      }

                      Future.delayed(Duration(milliseconds: 100), () {
                        if (context.mounted) Navigator.pop(context);
                      });
                    },
            icon: Icon(
              isInterested ? Icons.favorite : Icons.favorite_border,
              color: isInterested ? Colors.white : AppColor.blue,
              size: 20,
            ),
            label: Text(
              isInterested
                  ? AppLocalizations.of(context)!.alreadyInterested
                  : AppLocalizations.of(context)!.imInterested,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isInterested ? Colors.white : AppColor.blue,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isInterested
                      ? AppColor.primaryColor.withOpacity(0.7)
                      : Colors.white,
              foregroundColor: isInterested ? Colors.white : AppColor.blue,
              elevation: isInterested ? 0 : 2,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color:
                      isInterested
                          ? Colors.transparent
                          : AppColor.blue.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
