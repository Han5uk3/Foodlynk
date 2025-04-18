import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/donation_model.dart';
import 'package:saver_bbk_main/modules/food_share/bloc/food_share_bloc.dart';
import 'package:saver_bbk_main/modules/food_share/donation_details.dart';
import 'package:saver_bbk_main/modules/food_share/widgets/sheet.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DonnationCards extends StatefulWidget {
  final DonationModel item;
  final bool isBenificiary;
  final bool isDonor;
  final bool itsMy;
  final bool isFromHomePage;
  final Function(bool, String, String)? onInterestToggled;

  const DonnationCards({
    super.key,
    required this.item,
    required this.isBenificiary,
    required this.isDonor,
    this.onInterestToggled,
    required this.itsMy,
    this.isFromHomePage = false,
  });

  @override
  State<DonnationCards> createState() => _DonnationCardsState();
}

class _DonnationCardsState extends State<DonnationCards> {
  bool isInterested = false;

  @override
  void initState() {
    super.initState();
    isInterested = widget.item.isUserInterested;
  }

  @override
  void didUpdateWidget(DonnationCards oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.item.isUserInterested != widget.item.isUserInterested) {
      setState(() {
        isInterested = widget.item.isUserInterested;
      });
    }
  }

  void _showAlreadyInterestedAlert() {
    SaverSnackBar.show(
      context: context,
      message:
          AppLocalizations.of(context)!.youAreAlreadyInQueuePleaseWaitUntil,
      isTrue: true,
    );
  }

  void _showDetailBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, scrollController) {
          return FoodShareDetailBottomSheet(
            item: widget.item,
            isBenificiary: widget.isBenificiary,
            itsMy: widget.itsMy,
            onInterestToggled: widget.onInterestToggled,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isFromHomePage
          ? _showDetailBottomSheet
          : widget.item.status == "A"
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DonationDetails(
                        isDonor: !widget.isBenificiary,
                        isView: true,
                        isFromCard: true,
                        model: widget.item,
                      ),
                    ),
                  );
                },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isBenificiary)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: AppColor.greenshade.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.item.image ?? "",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: Icon(
                              Icons.restaurant,
                              color: AppColor.primaryColor.withOpacity(0.5),
                              size: 32,
                            ),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.restaurant,
                              color: AppColor.primaryColor.withOpacity(0.5),
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: !widget.isBenificiary ? 15 : 0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (!widget.isBenificiary)
                              Expanded(
                                child: Text(
                                  widget.item.foodName ?? "Food Item",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            if (widget.isBenificiary)
                              Expanded(
                                child: Text(
                                  widget.isBenificiary
                                      ? widget.item.foodType ?? "General"
                                      : widget.item.foodName ?? "Food Item",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            _buildStatusBadge(),
                          ],
                        ),
                        SizedBox(height: 8),
                        widget.isDonor
                            ? _buildDonatedDateRow()
                            : _buildReceivedOnDateRow(),
                        SizedBox(height: 8),
                        widget.isDonor
                            ? _buildServesRow()
                            : _buildDonatedByRow(),
                        if (widget.isBenificiary &&
                            widget.item.contactName != null &&
                            widget.item.contactName!.isNotEmpty)
                          Column(
                            children: [
                              SizedBox(height: 8),
                              _buildContactInfoRow(),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (widget.item.status == "A")
                SizedBox()
              else if (!widget.itsMy)
                _buildInterestButtonRow(),
              if (widget.itsMy && widget.item.status != "A")
                _showCountOfRequests(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestButtonRow() {
    return BlocConsumer<FoodShareBloc, FoodShareState>(
      listener: (context, state) {
        if (state is RequestAddedSuccessState &&
            state.itemId == widget.item.id) {
          setState(() {
            isInterested = state.isIntrested;
          });

          SaverSnackBar.show(
            context: context,
            message: isInterested
                ? AppLocalizations.of(context)!.requestSent
                : "Request Withdrawn",
            isTrue: true,
          );
          return;
        }

        if (state is RequestAddedFailedState &&
            state.itemId == widget.item.id) {
          SaverSnackBar.show(
            context: context,
            message: "Failed: ${state.errorMessage}",
            isTrue: false,
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isInterested
                ? _showAlreadyInterestedAlert
                : () {
                    setState(() {
                      isInterested = true;
                    });

                    if (widget.onInterestToggled != null) {
                      widget.onInterestToggled!(
                        true,
                        widget.item.id ?? "",
                        widget.item.type ?? "",
                      );
                    } else {
                      context.read<FoodShareBloc>().add(
                            IntrestedFoodShareEvent(
                              id: widget.item.id ?? "",
                              type: widget.item.type ?? "",
                              isInterested: true,
                            ),
                          );
                    }
                  },
            icon: Icon(
              isInterested ? Icons.favorite : Icons.favorite_border,
              color: isInterested ? Colors.red : AppColor.blue,
              size: 18,
            ),
            label: Text(
              isInterested
                  ? AppLocalizations.of(context)!.interested
                  : AppLocalizations.of(context)!.imInterested,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isInterested ? Colors.white : AppColor.blue,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isInterested ? AppColor.primaryColor : Colors.white,
              foregroundColor: isInterested ? Colors.white : AppColor.blue,
              elevation: isInterested ? 0 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isInterested
                      ? Colors.transparent
                      : AppColor.blue.withOpacity(0.5),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge() {
    final bool isPending = widget.item.status == "P";
    return Row(
      children: [
        if (widget.item.foodType != null && widget.item.foodType!.isNotEmpty)
          _buildFoodTypeChip(),
        Container(
          margin: EdgeInsets.only(left: 8),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isPending ? AppColor.lightYellow : AppColor.lightGreen,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPending ? Icons.schedule : Icons.check_circle_outline,
                size: 12,
                color: isPending ? AppColor.yellow : AppColor.primaryColor,
              ),
              SizedBox(width: 4),
              Text(
                isPending
                    ? AppLocalizations.of(context)!.pending
                    : AppLocalizations.of(context)!.picked,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isPending ? AppColor.yellow : AppColor.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
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
        SizedBox(width: 6),
        Expanded(
          child: Text(
            "${AppLocalizations.of(context)!.donatedOn} ${DateFormatHelper.ddmmyyyy(widget.item.createdAt ?? DateTime.now())}",
            style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
          ),
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
        SizedBox(width: 6),
        Expanded(
          child: Text(
            "${AppLocalizations.of(context)!.receivedOn} ${DateFormatHelper.ddmmyyyy(widget.item.createdAt ?? DateTime.now())}",
            style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
          ),
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
        SizedBox(width: 6),
        Text(
          "${AppLocalizations.of(context)!.serves} ${widget.item.noOfServe ?? 0}",
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
        SizedBox(width: 6),
        Text(
          "${AppLocalizations.of(context)!.donatedBy} ${widget.item.contactName ?? AppLocalizations.of(context)!.anonymous}",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
      ],
    );
  }

  Widget _buildContactInfoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.amber.withOpacity(0.2),
          child: Icon(Icons.phone_outlined, size: 14, color: Colors.orange),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            "${AppLocalizations.of(context)!.contact} ${widget.item.contactName ?? ""} ${widget.item.contactMobile != null ? '(${widget.item.contactContryCode ?? ""}${widget.item.contactMobile})' : ''}",
            style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodTypeChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        widget.item.foodType ?? "General",
        style: TextStyle(
          color: AppColor.primaryColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _showCountOfRequests() {
    int count = widget.item.request?.length ?? 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.notifications_active, color: Colors.blue, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "${AppLocalizations.of(context)!.youHave} $count ${AppLocalizations.of(context)!.pendingRequests}${count == 1 ? '' : 's'}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
