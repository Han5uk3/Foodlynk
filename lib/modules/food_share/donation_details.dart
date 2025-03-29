import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/calender.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/image_picker.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class DonationDetails extends StatefulWidget {
  const DonationDetails({
    super.key,
    required this.isDonor,
    required this.isView,
  });

  final bool isDonor;
  final bool isView;
  @override
  State<DonationDetails> createState() => _DonationDetailsState();
}

class _DonationDetailsState extends State<DonationDetails> {
  TextEditingController foodNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  TextEditingController yourNameController = TextEditingController();
  TextEditingController yourPhoneController = TextEditingController();
  TextEditingController serveCountController = TextEditingController();
  String terms =
      "I certify that the food I donated is safe to eat and has been stored in tightly sealed containers in accordance with health guidelines. I pledge to bear full and legal responsibility for all consequences of its use and disposal. I also release (Ne'ma Savers) from all liability for the food I donated.";
  File? _imageFile;
  bool tcvalue = false;
  List<String> items = [
    "diary",
    "Meat",
    "Vegetable",
    "Fruit",
    "Oils",
    "Poultry",
    "Seafood",
  ];
  String selectedItem = "";
  String selectedCode = "+91";
  DateTime selectedDate = DateTime.now();
  List<String> code = [
    "+91",
    "+966",
    "+965",
    "+974",
    "+971",
    "+970",
    "+973",
    "+98",
    "+968",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        widget.isDonor
            ? widget.isView
                ? "Donation Details"
                : "Add Donation"
            : widget.isView
            ? "Request Details"
            : "New Request",
        context,
        isneedtopop: true,
        iswhite: true,
        actions:
            widget.isView
                ? [
                  IconButton(
                    onPressed: () {
                      _showDeleteDialog(widget.isDonor);
                    },
                    icon: Icon(Icons.delete, color: AppColor.red),
                  ),
                ]
                : [],
      ),
      body:
          widget.isDonor
              ? _buildDonorBody(widget.isView)
              : _buildBeneficiaryBody(widget.isView),
      bottomNavigationBar:
          widget.isView
              ? widget.isDonor
                  ? Padding(
                    padding: const EdgeInsets.only(
                      top: 14,
                      left: 14,
                      right: 14,
                      bottom: 24,
                    ),
                    child: SaverButton(
                      text: "Donate",
                      onPressed: () {
                        widget.isDonor
                            ? log(
                              "Donor data :foodName: ${foodNameController.text},foodType: $selectedItem, Serves: ${serveCountController.text}, description: ${descriptionController.text}, expiryDate: $selectedDate, pickupLocation: ${locationNameController.text}, uploadedImage: ${_imageFile!.path} ",
                            )
                            : log(
                              "Beneficiary data: foodType: $selectedItem,pickupLocation: ${locationNameController.text},yourName: ${yourNameController.text},countryCode: $selectedCode, yourPhone: ${yourPhoneController.text}",
                            );
                      },
                    ),
                  )
                  : null
              : Padding(
                padding: const EdgeInsets.only(
                  top: 14,
                  left: 14,
                  right: 14,
                  bottom: 24,
                ),
                child: SaverButton(
                  text: widget.isDonor ? "Submit Donation" : "Submit Request",
                  onPressed: () {
                    widget.isDonor
                        ? log(
                          "Donor data :foodName: ${foodNameController.text},foodType: $selectedItem, Serves: ${serveCountController.text}, description: ${descriptionController.text}, expiryDate: $selectedDate, pickupLocation: ${locationNameController.text}, uploadedImage: ${_imageFile!.path} ",
                        )
                        : log(
                          "Beneficiary data: foodType: $selectedItem,pickupLocation: ${locationNameController.text},yourName: ${yourNameController.text},countryCode: $selectedCode, yourPhone: ${yourPhoneController.text}",
                        );
                  },
                ),
              ),
    );
  }

  _buildDonorBody(isView) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: IgnorePointer(
          ignoring: isView,
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isView
                  ? Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.yellow,
                          ), // change border and text color for after accepted
                        ),
                        child: Text(
                          textAlign: TextAlign.justify,
                          "This item is awaiting acceptance from beneficiary", // is already accepted(donated) "This request has been accepted and is awaiting pickup"
                          style: TextStyle(color: AppColor.yellow),
                        ),
                      ),
                    ],
                  )
                  : SizedBox.shrink(),
              Text("Food Name"),
              SaverTextField(
                hintText: "Enter food name",
                controller: foodNameController,
              ),
              SizedBox(height: 8),
              Text("Food Type"),
              SaverDropdown(
                items: items,
                selectedItem: selectedItem,
                onChanged: (value) {
                  setState(() {
                    selectedItem = value!;
                  });
                },
              ),
              SizedBox(height: 8),
              Text("Number of Serve(s)"),
              SaverTextField(
                hintText: "Enter number of serve(s)",
                controller: serveCountController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              SizedBox(height: 8),
              Text("Description"),
              SizedBox(
                height: 120,
                child: SaverTextField(
                  minLines: 7,
                  maxlines: 10,
                  hintText: "Describe why you are donating it...",
                  controller: descriptionController,
                ),
              ),
              SizedBox(height: 8),
              Text("Expiry Date"),
              ShowCalendar(
                isEdit: false,
                restrictBackDates: true,
                initialDate: DateTime.now(),
                onDatePicked: _onDatePicked,
              ),
              SizedBox(height: 8),
              Text("Pickup Location"),
              SaverTextField(
                hintText: "Enter pickup location",
                controller: locationNameController,
                suffixIcon: Icons.location_on_outlined,
                suffixIconColor: Colors.black,
              ),
              SizedBox(height: 8),
              Text(isView ? "Uploaded Image" : "Upload Image"),
              Row(
                children: [
                  if (_imageFile != null)
                    Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Center(
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_imageFile!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: SizedBox(
                            width: 100,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _imageFile = null;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.white70,
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      color: AppColor.black,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  _imageFile == null
                      ? ImagePickerButton(
                        isFood: false,
                        onImageSelected: _setImage,
                      )
                      : SizedBox(),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: AppColor.primaryColor,

                    value: isView ? true : tcvalue,
                    onChanged: (setValue) {
                      isView
                          ? null
                          : setState(() {
                            tcvalue = setValue!;
                          });
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        terms,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _setImage(File image) {
    setState(() {
      _imageFile = image;
    });
  }

  _onDatePicked(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  _buildBeneficiaryBody(isView) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: IgnorePointer(
          ignoring: isView,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text("Food Type Required"),
              SaverDropdown(
                items: items,
                hint: "Choose",
                selectedItem: selectedItem,
                onChanged: (value) {
                  setState(() {
                    selectedItem = value!;
                  });
                },
              ),
              SizedBox(height: 8),
              Text("Preferred Pickup Location"),
              SaverTextField(
                hintText: "Choose",
                controller: locationNameController,
                suffixIcon: Icons.location_on_outlined,
                suffixIconColor: Colors.black,
              ),
              SizedBox(height: 6),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 4),
              Text(
                "Contact Info (Optional)",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text("Your Name"),

              SaverTextField(
                hintText: "Enter your name",
                controller: yourNameController,
              ),
              SizedBox(height: 8),
              Text("Mobile Number"),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.21,
                    child: SaverDropdown(
                      items: code,
                      hint: "+91",
                      selectedItem: selectedCode,
                      onChanged: (value) {
                        setState(() {
                          selectedCode = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SaverTextField(
                      hintText: "Enter mobile number",

                      controller: yourPhoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
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

  _showDeleteDialog(isDonor) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(isDonor ? 'Delete Donation' : 'Delete Request'),
          content: Text(
            isDonor
                ? 'Are you sure you want to delete this donation?'
                : 'Are you sure you want to delete this request?',
          ),
          actions: [
            Row(
              spacing: 20,
              children: [
                Expanded(
                  child: SaverButton(
                    text: "No",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: SaverButton(
                    color: AppColor.red,
                    text: "Yes",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
