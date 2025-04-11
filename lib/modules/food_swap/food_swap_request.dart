import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/calender.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/food_swap_model.dart';
import 'package:saver_bbk_main/modules/food_swap/bloc/food_swap_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodSwapRequest extends StatefulWidget {
  const FoodSwapRequest({super.key, required this.items});

  final FoodSwapModel items;

  @override
  State<FoodSwapRequest> createState() => _FoodSwapRequestState();
}

class _FoodSwapRequestState extends State<FoodSwapRequest> {
  DateTime _dateTime = DateTime.now();
  DateTime selectedTime = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String dayT = "AM";
  String? selectedItem;
  String? selectedItemId;
  FoodSwapModel? selectedSwapItem;
  TextEditingController locationController = TextEditingController();

  late Future<List<FoodSwapModel>> _swapListFuture;

  @override
  void initState() {
    super.initState();
    _swapListFuture = Services.getUserSwapListFuture();
  }

  void _onDatePicked(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  setTimeOfDay() {
    setState(() {
      dayT = selectedTime.hour < 12 ? "AM" : "PM";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        AppLocalizations.of(context)!.foodSwapRequest,
        context,

        isneedtopop: true,
        iswhite: true,
      ),
      body: BlocListener<FoodSwapBloc, FoodSwapState>(
        listener: (context, state) {
          if (state is RequestFoodSwapSuccessState) {
            Navigator.pop(context);
            SaverSnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.yourRequesthasBeenSent,
              isTrue: true,
            );
          }
          if (state is RequestFoodSwapError) {
            SaverSnackBar.show(
              context: context,
              message: "Failed to send request. Please try again later.",
              isTrue: false,
            );
          }
        },
        child: SingleChildScrollView(
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
                  AppLocalizations.of(context)!.yourSwapItem,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(height: 10),
                _buildSwapItemDropdown(),
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.pickupLocation,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(height: 10),
                SaverTextField(
                  hintText: AppLocalizations.of(context)!.enterPickupLocation,
                  controller: locationController,
                  suffixIcon: Icons.location_on_outlined,
                  suffixIconColor: AppColor.black,
                ),
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.pickupDateAndTime,
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
      ),
      bottomNavigationBar: BlocBuilder<FoodSwapBloc, FoodSwapState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 24),
            child: SaverButton(
              text: AppLocalizations.of(context)!.submitSwapRequest,
              isLoading: state is RequestFoodSwapLoadingState,
              onPressed: () {
                if (selectedItem == null ||
                    locationController.text.isEmpty ||
                    selectedDate == null ||
                    selectedTime == null) {
                  SaverSnackBar.show(
                    context: context,
                    message:
                        AppLocalizations.of(context)!.pleaseFillInAllFields,
                    isTrue: false,
                  );
                  return;
                } else {
                  context.read<FoodSwapBloc>().add(
                    RequestFoodSwapEvent(
                      uid: Services.uid,
                      acceptedSwapItem: selectedItem,
                      acceptedSwapItemId: selectedItemId,
                      pickupDate: selectedDate,
                      pickupLocation: locationController.text,
                      pickupTime: selectedTime,
                      swapId: widget.items.id,
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSwapItemDropdown() {
    return FutureBuilder<List<FoodSwapModel>>(
      future: _swapListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            "Error fetching swap list: ${snapshot.error}",
            style: TextStyle(color: Colors.red),
          );
        }

        List<FoodSwapModel> items = snapshot.data ?? [];

        List<String> dropdownItems =
            items.isNotEmpty
                ? items.map((item) => item.name ?? "No Name").toList()
                : [AppLocalizations.of(context)!.noItemAvailable];

        String defaultValue =
            dropdownItems.contains(selectedItem)
                ? selectedItem!
                : dropdownItems.first;

        return SaverDropdown(
          hint: "Choose from my listings",
          items: dropdownItems,
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          selectedItem: defaultValue,
          onChanged: (value) {
            setState(() {
              selectedItem = value;

              // Find the selected item from the list
              selectedSwapItem = items.firstWhere(
                (item) => item.name == value,
                orElse: () => FoodSwapModel(), // fallback in case not found
              );

              selectedItemId = selectedSwapItem?.id;
            });
          },
        );
      },
      key: ValueKey(selectedItem),
    );
  }

  Widget _buildItemDetailsRow(FoodSwapModel items, {required bool isPending}) {
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

  Widget _buildItemHeaderRow(FoodSwapModel items, bool isPending) {
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
              isPending
                  ? AppLocalizations.of(context)!.pending
                  : AppLocalizations.of(context)!.available,
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

  Widget _buildExpiryDateRow(FoodSwapModel items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.greenshade,
          child: loadsvg("assets/icons/expiry.svg"),
        ),
        Text(
          " ${AppLocalizations.of(context)!.expiryDate}: ${DateFormatHelper.ddmmyyyy(items.expiredDate ?? DateTime.now())}",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
      ],
    );
  }

  Widget _buildLocationAndQuantityRow(FoodSwapModel items) {
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
          AppLocalizations.of(context)!.location,
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
        SizedBox(width: 5),
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.lightRed,
          child: Icon(size: 14, Icons.list_outlined, color: AppColor.red),
        ),
        Text(
          " ${AppLocalizations.of(context)!.quantity}: ${items.quantity}",
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
                      text: AppLocalizations.of(context)!.cancel,
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
                      text: AppLocalizations.of(context)!.done,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedTime = _dateTime;
                          setTimeOfDay();
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
      is24HourMode: false,
      isShowSeconds: false,
      isForce2Digits: true,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
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
