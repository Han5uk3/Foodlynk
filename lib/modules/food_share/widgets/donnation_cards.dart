import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/donation_model.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class DonnationCards extends StatelessWidget {
  final DonationModel item;
  final int tabIndex;
  final bool isBenificiary;
  const DonnationCards({
    super.key,
    required this.item,
    required this.tabIndex,
    required this.isBenificiary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder:
        //         (context) => DonationDetails(isDonor: isDonor, isView: true),
        //   ),
        // );
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
                  isBenificiary
                      ? SizedBox()
                      : Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: item.image ?? "",
                          placeholder: (context, url) => Icon(Icons.image),
                          errorWidget:
                              (context, url, error) => Icon(Icons.image),
                        ),
                      ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            isBenificiary
                                ? SizedBox()
                                : Expanded(
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    item.foodName ?? "NO",
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
                                    item.status == "P"
                                        ? AppColor.lightYellow
                                        : AppColor.lightGreen,
                              ),
                              height: 27,
                              child: Center(
                                child:
                                    item.status == "P"
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
                        tabIndex == 0
                            ? _buildDonatedDateRow()
                            : _buildReceivedOnDateRow(),
                        SizedBox(height: 5),
                        tabIndex == 0
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
          " Recieved On: ${DateFormatHelper.ddmmyyyy(item.createdAt ?? DateTime.now())}",
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
          " Serves: ${item.noOfServe}",
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
          "Donated By: 2",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
      ],
    );
  }
}
