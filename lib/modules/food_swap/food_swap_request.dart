import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/calender.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class FoodSwapRequest extends StatefulWidget {
  const FoodSwapRequest({super.key, required this.items});

  final Items items;

  @override
  State<FoodSwapRequest> createState() => _FoodSwapRequestState();
}

class _FoodSwapRequestState extends State<FoodSwapRequest> {
  void _onDatePicked(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  DateTime _dateTime = DateTime.now();
  DateTime selectedTime = DateTime.now();
  setTimeOfDay() async {
    String daytime = selectedTime.hour < 12 ? "AM" : "PM";
    setState(() {
      dayT = daytime;
    });
  }

  String dayT = "AM";
  DateTime selectedDate = DateTime.now();
  List<String> items = ["Item 1", "Item 2", "Item 3"];
  String? selectedItem = "";
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, bottom: 24),
        child: SaverButton(
          text: "Submit Swap Request",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      appBar: saverAppBar(
        "Food Swap Request",
        context,
        isneedchat: true,
        isneedtopop: true,
        iswhite: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14, bottom: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildItemDetailsRow(widget.items, isPending: false),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Your Swap Item",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: 10),
              SaverDropdown(
                hint: "Choose from my listings",
                items: items,
                selectedItem: selectedItem!,
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                "Pickup Location",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: 10),
              SaverTextField(
                hintText: "Enter pickup location",
                controller: locationController,
                suffixIcon: Icons.location_on_outlined,
                suffixIconColor: AppColor.black,
              ),
              SizedBox(height: 20),
              Text(
                "Pickup Date & Time",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: 10),

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ShowCalendar(
                      isEdit: false,
                      restrictBackDates: true,
                      initialDate: DateTime.now(),
                      onDatePicked: _onDatePicked,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildTimePickerButton(
                      formatTime(selectedTime),
                      buildTimePopup,
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

  Widget _buildItemDetailsRow(Items items, {required bool isPending}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, right: 12),
          child: Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: AppColor.white,
              border: Border.all(color: AppColor.lightGrey200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(Icons.image, color: AppColor.lightGrey200),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItemHeaderRow(items, isPending),
              _buildExpiryDateRow(items),
              _buildLocationAndQuantityRow(items),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemHeaderRow(Items items, bool isPending) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          items.name ?? "",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Container(
          margin: EdgeInsets.only(right: 12),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isPending ? AppColor.lightYellow : AppColor.greenshade,
          ),
          height: 27,
          child: Center(
            child: Text(
              isPending ? "pending" : "available",
              style: TextStyle(
                fontSize: 12,
                color: isPending ? AppColor.yellow : AppColor.green,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpiryDateRow(Items items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.greenshade,
          child: loadsvg("assets/icons/expiry.svg"),
        ),
        Text(
          " Expiry Date: ${DateFormatHelper.ddmmyyyy(items.expiredDate ?? DateTime.now())}",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
      ],
    );
  }

  Widget _buildLocationAndQuantityRow(Items items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.lightblue,
          child: Icon(
            size: 14,
            Icons.location_on_outlined,
            color: AppColor.blue,
          ),
        ),
        Text(
          " Location: ",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
        SizedBox(width: 5),
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.lightRed,
          child: Icon(size: 14, Icons.list_outlined, color: AppColor.red),
        ),
        Text(
          " Quantity: ${items.quantity}",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
      ],
    );
  }

  Widget _buildTimePickerButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.lightGrey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
        ),
      ),
    );
  }

  buildTimePopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: Text("Select Time", style: TextStyle(color: AppColor.black)),
          content: IntrinsicHeight(child: hourMinute12H()),
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: SaverOutlineButton(
                      text: "Cancel",
                      borderColor: AppColor.red,
                      textColor: AppColor.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SaverButton(
                      text: "Done",
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedTime = _dateTime;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget hourMinute12H() {
    return TimePickerSpinner(
      normalTextStyle: TextStyle(color: AppColor.lightGrey200, fontSize: 22),
      highlightedTextStyle: TextStyle(
        color: AppColor.primaryColor,
        fontSize: 30,
      ),
      time: _dateTime,
      is24HourMode: false, // Ensures it's in 12-hour format
      isShowSeconds: false,
      isForce2Digits: true, // Ensures consistent formatting
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
          setTimeOfDay();
        });
      },
    );
  }

  String formatTime(DateTime time) {
    final hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }
}
