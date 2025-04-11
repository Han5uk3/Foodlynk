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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  late TabController _tabController;
  bool _isLoading = false;

  final Set<String> _processingRequests = {};
  bool _isNavigatingToChat = false;

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
      serveCountController.text = widget.model.noOfServe?.toString() ?? "";
      tcvalue = widget.model.isAccpected ?? false;
      selectedItem = widget.model.foodType ?? "";
      selectedCode = widget.model.contactContryCode ?? "+965";
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
      backgroundColor: Colors.grey[50],
      appBar: saverAppBar(
        widget.isFromCard
            ? AppLocalizations.of(context)!.requestDetails
            : widget.isDonor
            ? AppLocalizations.of(context)!.addDonation
            : AppLocalizations.of(context)!.addBeneficairy,
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
            !widget.isDonor && widget.isFromCard
                ? null
                : widget.isFromCard
                ? TabBar(
                  controller: _tabController,
                  labelColor: AppColor.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColor.primaryColor,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.incomingRequests),
                    Tab(text: AppLocalizations.of(context)!.details),
                  ],
                )
                : null,
      ),
      body: BlocListener<FoodShareBloc, FoodShareState>(
        listener: (context, state) {
          if (state is NewDonationLoadingState ||
              state is NewBenificiaryLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }

          if (state is NewDonationSuccessState) {
            Navigator.pop(context);
            Navigator.pop(context);
            SaverSnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.donationAddedSuccessfully,
              isTrue: true,
            );
          }
          if (state is NewBenificiarySuccessState) {
            Navigator.pop(context);
            Navigator.pop(context);
            SaverSnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.requestAddedSuccessfully,
              isTrue: true,
            );
          }
          if (state is NewBenificiaryFailedState) {
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          }
          if (state is NewDonationFailedState) {
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          }
          if (state is DeleteRequestSuccessState) {
            Navigator.pop(context);
            Navigator.pop(context);
            SaverSnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.requestDeletedSuccessfully,
              isTrue: true,
            );
          }
          if (state is DeleteRequestFailedState) {
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          }
          if (state is DeclineRequestSuccessState) {
            Navigator.pop(context);
            SaverSnackBar.show(
              context: context,
              message: "Request Declined Successfully",
              isTrue: true,
            );
          }
          if (state is DeclineRequestFailedState) {
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          }
        },
        child:
            !widget.isDonor && widget.isFromCard
                ? _buildIncomingRequestsTab()
                : widget.isFromCard
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
          widget.isDonor || !widget.isFromCard ? _buildSubmitButton() : null,
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SaverButton(
        text:
            widget.isDonor
                ? AppLocalizations.of(context)!.submitDonation
                : AppLocalizations.of(context)!.submitRequest,
        isLoading: _isLoading,
        onPressed: _validateAndSubmit,
      ),
    );
  }

  void _validateAndSubmit() {
    if (widget.isDonor) {
      if (foodNameController.text.isEmpty ||
          selectedItem.isEmpty ||
          serveCountController.text.isEmpty ||
          locationNameController.text.isEmpty) {
        SaverSnackBar.show(
          context: context,
          message: AppLocalizations.of(context)!.pleaseFillInAllRequiredFields,
          isTrue: false,
        );
        return;
      }

      if (!tcvalue) {
        SaverSnackBar.show(
          context: context,
          message:
              AppLocalizations.of(context)!.pleaseAcceptTheTermsAndConditions,
          isTrue: false,
        );
        return;
      }

      context.read<FoodShareBloc>().add(
        AddNewFoodDonationEvent(
          model: DonationModel(
            foodName: foodNameController.text,
            foodType: selectedItem,
            discription: descriptionController.text,
            noOfServe: int.tryParse(serveCountController.text) ?? 0,
            raisedBy: Services.uid,
            image: _imageFile?.path ?? "",
            pickUpLocation: locationNameController.text,
            isAccpected: tcvalue,
            expiredDate: selectedDate,
          ),
        ),
      );
    } else {
      if (selectedItem.isEmpty || locationNameController.text.isEmpty) {
        SaverSnackBar.show(
          context: context,
          message:
              AppLocalizations.of(context)!.pleaseSelectFoodTypeAndLocation,
          isTrue: false,
        );
        return;
      }

      context.read<FoodShareBloc>().add(
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
    }
  }

  Widget _buildIncomingRequestsTab() {
    return MultiBlocListener(
      listeners: [
        BlocListener<CommunityBloc, CommunityState>(
          listener: (context, state) {
            if (state.status == ChatStatus.goToChatPage &&
                !_isNavigatingToChat) {
              setState(() {
                _isNavigatingToChat = true;
              });

              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (context) => Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                            SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.openingChat,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
              );

              Future.delayed(Duration(milliseconds: 800), () {
                if (mounted) {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChatPage(isFromNotifications: false),
                    ),
                  ).then((_) {
                    if (mounted) {
                      setState(() {
                        _isNavigatingToChat = false;
                        _processingRequests.clear();
                      });
                    }
                  });
                }
              });
            }

            if (state.status == ChatStatus.error) {
              setState(() {
                _isNavigatingToChat = false;
              });

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
            return Center(child: SaverLoader());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  SizedBox(height: 16),
                  Text(
                    "Error loading requests",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final incomingRequests = snapshot.data;

          if (incomingRequests == null || incomingRequests.isEmpty) {
            return EmptyList(
              message: AppLocalizations.of(context)!.noRequestAvailableYet,
              subMessage:
                  AppLocalizations.of(context)!.whenSomeoneRequestsThisDonation,
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: incomingRequests.length,
            itemBuilder: (context, index) {
              final request = incomingRequests[index];
              final String raisedUid = request['raisedUid'] ?? "";
              final String interestedId = request['interestedId'] ?? "";
              final String requestId = request['id'] ?? "";

              return _buildRequestCard(
                request,
                raisedUid,
                interestedId,
                requestId,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(
    Map<String, dynamic> request,
    String raisedUid,
    String interestedId,
    String requestId,
  ) {
    final bool isAcceptProcessing = _processingRequests.contains(
      "accept_$requestId",
    );
    final bool isDeclineProcessing = _processingRequests.contains(
      "decline_$requestId",
    );

    return Card(
      color: AppColor.white,
      key: ValueKey(requestId),
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: StreamBuilder<QuerySnapshot<UserModel>>(
        stream: Services.getUserDetails(uid: raisedUid),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 150,
              padding: EdgeInsets.all(16),
              child: Center(child: SaverLoader()),
            );
          }

          if (userSnapshot.hasError ||
              userSnapshot.data == null ||
              userSnapshot.data!.docs.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person_off, color: Colors.grey),
                  ),
                  SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context)!.userInformationNotAvailable,
                  ),
                ],
              ),
            );
          }

          final user = userSnapshot.data!.docs.first.data();
          final hasName = (user.firstName ?? "").isNotEmpty;
          final hasEmail = (user.email ?? "").isNotEmpty;
          final hasPhone = (user.phoneNumber ?? "").isNotEmpty;

          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                      child: Text(
                        hasName ? (user.firstName?[0] ?? "?") : "?",
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasName
                                ? "${user.firstName ?? ""} ${user.lastName ?? ""}"
                                : "Unknown User",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.requestReceivedRecently} ${_getTimeAgo(request['timestamp'])}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      if (hasEmail)
                        _infoRow(
                          Icons.email,
                          AppLocalizations.of(context)!.email,
                          user.email!,
                        ),
                      if (hasPhone)
                        _infoRow(
                          Icons.phone,
                          AppLocalizations.of(context)!.phone,
                          user.phoneNumber!,
                        ),
                      _infoRow(
                        Icons.calendar_today,
                        AppLocalizations.of(context)!.date,
                        DateFormatHelper.ddmmyyyyString(request['timestamp']),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SaverButton(
                        text: AppLocalizations.of(context)!.decline,
                        color: Colors.grey[300]!,
                        textColor: Colors.black87,
                        isLoading: isDeclineProcessing,
                        onPressed:
                            isDeclineProcessing ||
                                    isAcceptProcessing ||
                                    _isNavigatingToChat
                                ? () {}
                                : () {
                                  _showDeclineConfirmation(request, user);
                                },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SaverButton(
                        text: AppLocalizations.of(context)!.accept,
                        isLoading: isAcceptProcessing,
                        onPressed:
                            isDeclineProcessing ||
                                    isAcceptProcessing ||
                                    _isNavigatingToChat
                                ? () {}
                                : () {
                                  setState(() {
                                    _processingRequests.add(
                                      "accept_$requestId",
                                    );
                                  });

                                  context.read<FoodShareBloc>().add(
                                    AcceptFoodShareRequest(
                                      reqId: widget.model.id ?? '',
                                      type: widget.model.type ?? '',
                                      fcmToken: user.fcmToken ?? "",
                                      reciverUid: raisedUid,
                                      communityBloc:
                                          context.read<CommunityBloc>(),
                                      context: context,
                                    ),
                                  );
                                },
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
  }

  String _getTimeAgo(dynamic timestamp) {
    if (timestamp == null) return "recently";

    try {
      if (timestamp is Timestamp) {
        final DateTime dateTime = timestamp.toDate();
        final Duration difference = DateTime.now().difference(dateTime);

        if (difference.inDays > 0) {
          return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
        } else if (difference.inHours > 0) {
          return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
        } else if (difference.inMinutes > 0) {
          return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
        } else {
          return "just now";
        }
      }
      return "recently";
    } catch (e) {
      return "recently";
    }
  }

  void _showDeclineConfirmation(Map<String, dynamic> request, UserModel user) {
    final String requestId = request['interestedId'] ?? "";

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Decline Request"),
            content: Text(
              "Are you sure you want to decline the request from ${user.firstName ?? 'this user'}?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _processingRequests.add("decline_$requestId");
                  });
                  context.read<FoodShareBloc>().add(
                    DeclineFoodShareRequest(
                      reqId: widget.model.id ?? "",
                      intrestedId: requestId,
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.decline,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    if (value.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonorBody(bool isView) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IgnorePointer(
          ignoring: isView,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(AppLocalizations.of(context)!.foodInformation),
              _buildCard([
                Label(
                  text: AppLocalizations.of(context)!.foodName,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                SaverTextField(
                  hintText: AppLocalizations.of(context)!.enterFoodName,
                  controller: foodNameController,
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.fastfood,
                ),
                SizedBox(height: 16),
                Label(
                  text: AppLocalizations.of(context)!.foodType,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                SaverDropdown(
                  items: items,
                  selectedItem: selectedItem,
                  hint: AppLocalizations.of(context)!.selectFoodType,
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                Label(
                  text: AppLocalizations.of(context)!.numberOfServes,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                SaverTextField(
                  hintText: AppLocalizations.of(context)!.enterNumberOfServes,
                  controller: serveCountController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.people,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ]),

              SizedBox(height: 24),
              _buildSectionTitle(
                AppLocalizations.of(context)!.descriptionAndExpiry,
              ),
              _buildCard([
                Label(
                  text: AppLocalizations.of(context)!.description,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: SaverTextField(
                    minLines: 7,
                    maxlines: 10,
                    hintText:
                        AppLocalizations.of(
                          context,
                        )!.describeWhyYouAreDonatingIt,
                    controller: descriptionController,
                  ),
                ),
                SizedBox(height: 16),
                Label(
                  text: AppLocalizations.of(context)!.expiryDate,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                ShowCalendar(
                  isEdit: false,
                  restrictBackDates: true,
                  initialDate: DateTime.now(),
                  onDatePicked: _onDatePicked,
                ),
              ]),

              SizedBox(height: 24),
              _buildSectionTitle(
                AppLocalizations.of(context)!.locationAndImage,
              ),
              _buildCard([
                Label(
                  text: AppLocalizations.of(context)!.pickupLocation,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                SaverTextField(
                  hintText: AppLocalizations.of(context)!.enterPickupLocation,
                  controller: locationNameController,
                  prefixIcon: Icons.location_on_outlined,
                  suffixIcon: Icons.map,
                  suffixIconColor: AppColor.primaryColor,
                ),
                if (!widget.isFromCard) ...[
                  SizedBox(height: 16),
                  Label(
                    text: AppLocalizations.of(context)!.foodImage,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  _buildImageUploadSection(),
                ],
              ]),

              SizedBox(height: 16),
              _buildTermsAndConditions(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.primaryColor,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      color: AppColor.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_imageFile != null)
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _imageFile = null;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close, color: Colors.black, size: 20),
                    ),
                  ),
                ),
              ],
            )
          else
            Center(
              child: ImagePickerButton(
                isFood: true,
                onImageSelected: _setImage,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Card(
      color: AppColor.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.termsAndConditions,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: AppColor.primaryColor,
                  value: tcvalue,
                  onChanged: (setValue) {
                    setState(() {
                      tcvalue = setValue!;
                    });
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      AppLocalizations.of(context)!.iCertifyThatTheFood,
                      style: TextStyle(color: Colors.black87, fontSize: 13),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _setImage(File image) {
    setState(() {
      _imageFile = image;
    });
  }

  void _onDatePicked(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  Widget _buildBeneficiaryBody(bool isView) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IgnorePointer(
          ignoring: isView,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                AppLocalizations.of(context)!.requestInformation,
              ),
              _buildCard([
                Label(
                  text: AppLocalizations.of(context)!.foodTypeRequired,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                SaverDropdown(
                  items: items,
                  hint: AppLocalizations.of(context)!.selectFoodType,
                  selectedItem: selectedItem,
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                Label(
                  text: AppLocalizations.of(context)!.preferredPickupLocation,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                SaverTextField(
                  hintText:
                      AppLocalizations.of(context)!.enterPreferredLocation,
                  controller: locationNameController,
                  prefixIcon: Icons.location_on_outlined,
                  suffixIcon: Icons.map,
                  suffixIconColor: AppColor.primaryColor,
                ),
              ]),

              SizedBox(height: 24),
              _buildSectionTitle(
                AppLocalizations.of(context)!.contactInformation,
              ),
              _buildCard([
                Text(
                  AppLocalizations.of(context)!.thisInformationWillBeShared,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 16),
                Label(
                  text: AppLocalizations.of(context)!.yourName,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                SaverTextField(
                  hintText: AppLocalizations.of(context)!.enterYourName,
                  controller: yourNameController,
                  prefixIcon: Icons.person,
                ),
                SizedBox(height: 16),
                Label(
                  text: AppLocalizations.of(context)!.mobileNumber,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: yourPhoneController,
                    maxLength: 8,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText:
                          AppLocalizations.of(
                            context,
                          )!.enterEightDigitMobileNumber,
                      prefixText: '+965 - ',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ]),
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
          title: Text(
            isDonor
                ? 'Delete Donation'
                : AppLocalizations.of(context)!.deleteRequest,
          ),
          content: Text(
            isDonor
                ? 'Are you sure you want to delete this donation?'
                : AppLocalizations.of(
                  context,
                )!.areYouSureWantToDeletThisRequest,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: SaverButton(
                    text: AppLocalizations.of(context)!.no,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: SaverButton(
                    color: AppColor.red,
                    text: AppLocalizations.of(context)!.yes,
                    onPressed:
                        () => context.read<FoodShareBloc>().add(
                          DeleteFoodShareRequest(reqId: widget.model.id ?? ""),
                        ),
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
