import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/calender.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/empty_list.dart';
import 'package:saver_bbk_main/common_widget/image_picker.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/donation_model.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/modules/community/chat_page.dart';
import 'package:saver_bbk_main/modules/food_share/bloc/food_share_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class DonationDetails extends StatefulWidget {
  final DonationModel model;
  final bool isDonor;
  final bool isFromCard;
  final bool isView;
  const DonationDetails({
    super.key,
    required this.isDonor,
    required this.isView,
    required this.model,
    required this.isFromCard,
  });

  @override
  State<DonationDetails> createState() => _DonationDetailsState();
}

class _DonationDetailsState extends State<DonationDetails>
    with SingleTickerProviderStateMixin {
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

  // Tab controller for managing the tabs
  late TabController _tabController;

  @override
  void initState() {
    if (widget.isFromCard) {
      _tabController = TabController(length: 2, vsync: this);
      selectedDate = widget.model.expiredDate ?? DateTime.now();
      foodNameController.text = widget.model.foodName ?? "";
      descriptionController.text = widget.model.discription ?? "";
      locationNameController.text = widget.model.pickUpLocation ?? "";
      yourNameController.text = widget.model.contactName ?? "";
      yourPhoneController.text = widget.model.contactMobile ?? "";
      serveCountController.text = widget.model.noOfServe.toString();
      tcvalue = widget.model.isAccpected ?? false;
      // _imageFile = widget.model.imageFile ?? null;
      selectedItem = widget.model.foodType ?? "";
      selectedCode = widget.model.contactContryCode ?? "+91";

      selectedItem = widget.model.foodType ?? "";
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.isFromCard) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        widget.isFromCard
            ? "Request Details"
            : widget.isDonor
            ? "Add Donation"
            : "Add Benificary",
        context,
        isneedtopop: true,
        iswhite: true,
        actions:
            widget.isFromCard
                ? [
                  IconButton(
                    onPressed: () {
                      _showDeleteDialog(widget.isDonor);
                    },
                    icon: Icon(Icons.delete, color: AppColor.red),
                  ),
                ]
                : [],
        bottom:
            widget.isFromCard
                ? TabBar(
                  controller: _tabController,
                  labelColor: AppColor.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColor.primaryColor,
                  tabs: const [
                    Tab(text: "Incoming Requests"),
                    Tab(text: "Details"),
                  ],
                )
                : null,
      ),
      body: BlocListener<FoodShareBloc, FoodShareState>(
        listener: (context, state) {
          if (state is NewDonationSuccessState) {
            Navigator.pop(context);
            Navigator.pop(context);
            SaverSnackBar.show(
              context: context,
              message: "Donation Added",
              isTrue: true,
            );
          }
          if (state is NewBenificiarySuccessState) {
            Navigator.pop(context);
            Navigator.pop(context);
            SaverSnackBar.show(
              context: context,
              message: "Request Added",
              isTrue: true,
            );
          }
          if (state is NewBenificiaryFailedState) {
            SaverSnackBar.show(
              context: context,
              message: "Failed to Add Request",
              isTrue: false,
            );
          }
          if (state is NewDonationFailedState) {
            SaverSnackBar.show(
              context: context,
              message: "Failed to Add Donation",
              isTrue: false,
            );
          }
        },
        child:
            widget.isFromCard
                ? TabBarView(
                  controller: _tabController,
                  children: [
                    _buildIncomingRequestsTab(),
                    _buildDonorBody(widget.isView),
                  ],
                )
                : widget.isDonor
                ? _buildDonorBody(widget.isView)
                : _buildBeneficiaryBody(widget.isView),
      ),
      bottomNavigationBar:
          widget.isDonor || !widget.isFromCard
              ? BlocBuilder<FoodShareBloc, FoodShareState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 14,
                      left: 14,
                      right: 14,
                      bottom: 24,
                    ),
                    child: SaverButton(
                      text: "Submit Request",
                      isLoading:
                          state is NewDonationLoadingState ||
                          state is NewBenificiaryLoadingState,
                      onPressed: () {
                        widget.isDonor
                            ? context.read<FoodShareBloc>().add(
                              AddNewFoodDonationEvent(
                                model: DonationModel(
                                  foodName: foodNameController.text,
                                  foodType: selectedItem,
                                  discription: descriptionController.text,
                                  noOfServe: int.parse(
                                    serveCountController.text,
                                  ),
                                  raisedBy: Services.uid,
                                  image: _imageFile?.path ?? "",
                                  pickUpLocation: locationNameController.text,
                                  isAccpected: tcvalue,
                                  expiredDate: selectedDate,
                                ),
                              ),
                            )
                            : context.read<FoodShareBloc>().add(
                              AddNewBaneficiaryEvent(
                                model: DonationModel(
                                  foodType: selectedItem,
                                  pickUpLocation: locationNameController.text,
                                  contactName: yourNameController.text,
                                  contactContryCode: selectedCode,
                                  contactMobile: yourPhoneController.text,
                                ),
                              ),
                            );
                      },
                    ),
                  );
                },
              )
              : null,
    );
  }

  Widget _buildIncomingRequestsTab() {
    return MultiBlocListener(
      listeners: [
        BlocListener<CommunityBloc, CommunityState>(
          listener: (context, state) {
            if (state.status == ChatStatus.goToChatPage) {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ChatPage(
                          isFromNotifications: false,
                        ),
                  ),
                );
              }
            }

            if (state.status == ChatStatus.error) {
              SaverSnackBar.show(
                context: context,
                message: state.errorMessage ?? 'An error occurred',
                isTrue: false,
              );
            }
          },
        ),
      ],
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Services.getFoodShareRequest(widget.model.id ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SaverLoader();
          }
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final incomingRequests = snapshot.data;
          log(snapshot.data.toString());
          if (incomingRequests?.isEmpty ?? false) {
            return EmptyList(message: "No requests available");
          }

          return ListView.builder(
            padding: EdgeInsets.all(14),
            itemCount: incomingRequests?.length,
            itemBuilder: (context, index) {
              final request = incomingRequests?[index];
              final String raisedUid = request?['raisedUid'] ?? "";

              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 12),
                child: StreamBuilder<QuerySnapshot<UserModel>>(
                  stream: Services.getUserDetails(uid: raisedUid),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (userSnapshot.hasError ||
                        userSnapshot.data == null ||
                        userSnapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("User info not available"),
                      );
                    }

                    final user = userSnapshot.data!.docs.first.data();

                    return Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Request from ${user.firstName ?? "Unknown"} ${user.lastName ?? ""}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          _infoRow(Icons.email, "Email", user.email ?? "N/A"),
                          _infoRow(
                            Icons.phone,
                            "Phone",
                            user.phoneNumber ?? "N/A",
                          ),
                          _infoRow(
                            Icons.access_time,
                            "Requested At",
                            DateFormatHelper.ddmmyyyyString(
                              request?['timestamp'],
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: SaverButton(
                                  text: "Decline",
                                  color: Colors.grey,
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: SaverButton(
                                  text: "Accept",
                                  onPressed:
                                      () => context.read<FoodShareBloc>().add(
                                        AcceptFoodShareRequest(
                                          reqId: widget.model.id ?? '',
                                          fcmToken: user.fcmToken ?? "",
                                          reciverUid: raisedUid,

                                          communityBloc:
                                              context.read<CommunityBloc>(),
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Label(text: "Food Name"),
              SizedBox(height: 5),
              SaverTextField(
                hintText: "Enter food name",
                controller: foodNameController,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 8),
              Label(text: "Food Type"),
              SizedBox(height: 5),
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
              Label(text: "Number of Serve(s)"),
              SizedBox(height: 5),
              SaverTextField(
                hintText: "Enter number of serve(s)",
                controller: serveCountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              SizedBox(height: 8),
              Label(text: "Description"),
              SizedBox(height: 5),
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
              Label(text: "Expiry Date"),
              SizedBox(height: 5),
              ShowCalendar(
                isEdit: false,
                restrictBackDates: true,
                initialDate: DateTime.now(),
                onDatePicked: _onDatePicked,
              ),
              SizedBox(height: 8),
              Text("Pickup Location"),
              SizedBox(height: 5),
              SaverTextField(
                hintText: "Enter pickup location",
                controller: locationNameController,
                suffixIcon: Icons.location_on_outlined,
                suffixIconColor: Colors.black,
              ),
              SizedBox(height: 8),
              if (!widget.isFromCard) Text("Upload Image"),
              if (!widget.isFromCard) SizedBox(height: 5),
              if (!widget.isFromCard)
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
              children: [
                Expanded(
                  child: SaverButton(
                    text: "No",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 20),
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
