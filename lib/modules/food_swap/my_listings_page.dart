import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_selector/number_selector.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/calender.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/empty_list.dart';
import 'package:saver_bbk_main/common_widget/image_picker.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/food_swap_model.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/modules/community/chat_page.dart';
import 'package:saver_bbk_main/modules/food_swap/bloc/food_swap_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

class MyListingsPage extends StatefulWidget {
  final bool isEdit;
  final FoodSwapModel? items;
  final int? index;

  const MyListingsPage(
      {super.key, required this.isEdit, this.items, this.index});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  DateTime selectedExpiryDate = DateTime.now();
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    if (widget.index != null) {
      tabController.index = widget.index!;
    }
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        widget.isEdit
            ? AppLocalizations.of(context)!.myListing
            : AppLocalizations.of(context)!.addNewItem,
        context,
        isneedtopop: false,
        actions: widget.isEdit
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: IconButton(
                    style: ButtonStyle(
                      shape: const WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    icon: const Icon(CupertinoIcons.trash),
                    color: AppColor.red,
                    onPressed: () =>
                        _showDeleteFoodSwap(context, widget.items!),
                  ),
                ),
              ]
            : [],
        bottom: widget.isEdit
            ? PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      Divider(color: Colors.grey.shade200, thickness: 1),
                      SizedBox(
                        height: 40,
                        child: TabBar(
                          isScrollable: false,
                          physics: const BouncingScrollPhysics(),
                          tabs: [
                            Tab(
                              text: AppLocalizations.of(context)!.foodDeatils,
                            ),
                            Tab(text: AppLocalizations.of(context)!.requests),
                          ],
                          indicatorColor: AppColor.appbarColor,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          labelColor: AppColor.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 5,
                              color: AppColor.appbarColor,
                            ),
                          ),
                          controller: tabController,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: SizedBox(),
              ),
      ),
      body: BlocListener<FoodSwapBloc, FoodSwapState>(
        listener: (context, state) {
          if (state is FoodSwapSuccess) {
            Navigator.of(context).pop();
            SaverSnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.foodSwapSuccess,
              isTrue: true,
            );
          } else if (state is FoodSwapUpdateSuccessState) {
            Navigator.of(context).pop();
            SaverSnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.foodSwapUpdatedSuccessfuly,
              isTrue: true,
            );
          } else if (state is DeleteFromFoodSwapSuccessState) {
            SaverSnackBar.show(
              context: context,
              message:
                  AppLocalizations.of(context)!.foodSwapDeletedSuccessfully,
              isTrue: true,
            );
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is FoodSwapUpdateError) {
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          } else if (state is FoodSwapError) {
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          } else if (state is DeleteFromFoodSwapError) {
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          }
        },
        child: widget.isEdit
            ? TabBarView(
                controller: tabController,
                children: [
                  FoodDetails(isEditable: true, items: widget.items!),
                  RequestsDetails(foodSwapModel: widget.items!),
                ],
              )
            : FoodDetails(isEditable: false, items: widget.items!),
      ),
    );
  }

  void _showDeleteFoodSwap(BuildContext context, FoodSwapModel items) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<FoodSwapBloc, FoodSwapState>(
          builder: (context, state) {
            bool isLoadingDelete = state is DeleteFromFoodSwapLoadingState;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                AppLocalizations.of(context)!.deleteItem,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                "${AppLocalizations.of(context)!.areYouSureWantToDeletThis} ${items.name} ${AppLocalizations.of(context)!.itemThisActionCannotBeUndone}",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                TextButton(
                  onPressed: isLoadingDelete
                      ? null
                      : () {
                          context.read<FoodSwapBloc>().add(
                                RemoveItemFromFoodSwapEvent(
                                  swapId: items.id ?? "",
                                ),
                              );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                  child: isLoadingDelete
                      ? SaverLoader()
                      : Text(
                          AppLocalizations.of(context)!.delete,
                          style: TextStyle(color: AppColor.red),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class FoodDetails extends StatefulWidget {
  const FoodDetails({super.key, required this.isEditable, required this.items});

  final bool isEditable;
  final FoodSwapModel items;

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  final TextEditingController nameController = TextEditingController();
  String? selectedUnit;
  int numberOfQuantity = 0;
  String selectedCategory = "";
  DateTime selectedExpiryDate = DateTime.now();
  File? _imageFile;

  final List<String> unit = ["Kg", "Pcs", "ml", "Ltr", "gm", "Nos"];

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    if (widget.isEditable) {
      nameController.text = widget.items.name ?? "";
      selectedUnit = widget.items.unit;
      numberOfQuantity = widget.items.quantity ?? 0;
      selectedCategory = widget.items.category ?? "";
      selectedExpiryDate = widget.items.expiredDate ?? DateTime.now();
    }
  }

  void _onDatePicked(DateTime date) {
    setState(() {
      selectedExpiryDate = date;
    });
  }

  void _setImage(File image) {
    setState(() {
      _imageFile = image;
    });
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void _saveChanges() {
    if (nameController.text.isEmpty) {
      SaverSnackBar.show(
        context: context,
        message: AppLocalizations.of(context)!.plaeseenterItemName,
        isTrue: false,
      );
      return;
    }
    if (selectedUnit == null) {
      SaverSnackBar.show(
        context: context,
        message: AppLocalizations.of(context)!.pleaseSelectAUnitType,
        isTrue: false,
      );
      return;
    }
    if (selectedExpiryDate == null) {
      SaverSnackBar.show(
        context: context,
        message: AppLocalizations.of(context)!.pleaseSelectAnExpiryDate,
        isTrue: false,
      );
      return;
    }

    final Items item = Items(
      id: widget.items.id,
      name: nameController.text,
      quantity: numberOfQuantity,
      unit: selectedUnit ?? "",
      status: widget.items.status,
      category: selectedCategory,
      expiredDate: selectedExpiryDate,
    );

    if (widget.isEditable) {
      context.read<FoodSwapBloc>().add(UpdateItemInFoodSwapEvent(item: item));
    } else {
      context.read<FoodSwapBloc>().add(
            AddItemToFoodSwapEvent(item: item, imageFile: _imageFile),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(text: AppLocalizations.of(context)!.itemName),
              const SizedBox(height: 10),
              SaverTextField(
                hintText: AppLocalizations.of(context)!.garlicBread,
                controller: nameController,
              ),
              const SizedBox(height: 15),
              Label(text: AppLocalizations.of(context)!.quantity),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntrinsicWidth(
                    child: SaverDropdown(
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value;
                        });
                      },
                      items: unit,
                      selectedItem: selectedUnit ?? "",
                      hint: AppLocalizations.of(context)!.choose,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: NumberSelector.plain(
                      hasBorder: true,
                      showMinMax: false,
                      min: 1,
                      iconColor: Colors.grey.shade500,
                      borderRadius: 6,
                      borderColor: Colors.grey.shade300,
                      backgroundColor: Colors.white,
                      current: numberOfQuantity,
                      onUpdate: (newValue) {
                        setState(() {
                          numberOfQuantity = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                AppLocalizations.of(context)!.expiryDate,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ShowCalendar(
                isEdit: widget.isEditable,
                restrictBackDates: true,
                initialDate: selectedExpiryDate,
                onDatePicked: _onDatePicked,
              ),
              const SizedBox(height: 15),
              widget.isEditable
                  ? SizedBox()
                  : Text(
                      AppLocalizations.of(context)!.uploadImage,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              const SizedBox(height: 10),
              widget.isEditable
                  ? SizedBox()
                  : Row(
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
                                      onTap: _removeImage,
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
                        if (_imageFile == null)
                          ImagePickerButton(
                            isFood: false,
                            onImageSelected: _setImage,
                          ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          top: 14,
          left: 14,
          right: 14,
          bottom: 24,
        ),
        child: BlocBuilder<FoodSwapBloc, FoodSwapState>(
          builder: (context, state) {
            final bool isButtonLoading =
                state is FoodSwapLoading ? state.isLoading : false;
            return SaverButton(
              isLoading: isButtonLoading,
              text: widget.isEditable
                  ? AppLocalizations.of(context)!.saveChanges
                  : AppLocalizations.of(context)!.addToListing,
              onPressed: isButtonLoading ? () {} : _saveChanges,
            );
          },
        ),
      ),
    );
  }
}

class RequestsDetails extends StatefulWidget {
  final FoodSwapModel foodSwapModel;
  const RequestsDetails({super.key, required this.foodSwapModel});

  @override
  State<RequestsDetails> createState() => _RequestsDetailsState();
}

class _RequestsDetailsState extends State<RequestsDetails> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<FoodSwapBloc, FoodSwapState>(
            listener: (context, state) {
              if (state is RequestAcceptedError) {
                SaverSnackBar.show(
                  context: context,
                  message: state.errorMessage,
                  isTrue: false,
                );
              }
            },
          ),
          BlocListener<CommunityBloc, CommunityState>(
            listener: (context, state) {
              if (state.status == ChatStatus.goToChatPage) {
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatPage(isFromNotifications: false),
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
        child: widget.foodSwapModel.status == "A"
            ? EmptyList(
                message: AppLocalizations.of(context)!.alreadyAccepted,
              )
            : Padding(
                padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
                child: StreamBuilder<List<AcceptedSwapItem>>(
                  stream: Services.getRequestSwapListStream(
                    widget.foodSwapModel.id ?? "",
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Text(
                        AppLocalizations.of(context)!.noRequestsFound,
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SaverLoader();
                    }
                    if (snapshot.hasError) {
                      return Text(
                        "Error fetching requests: ${snapshot.error}",
                      );
                    }

                    if (snapshot.data!.isEmpty) {
                      return EmptyList(
                        message: AppLocalizations.of(context)!.noRequestsFound,
                        subMessage: AppLocalizations.of(
                          context,
                        )!
                            .checkBackLaterForNewRequests,
                      );
                    }
                    final acceptedSwapItem = snapshot.data!;
                    return ListView.builder(
                      itemCount: acceptedSwapItem.length,
                      itemBuilder: (context, index) {
                        final AcceptedSwapItem item = acceptedSwapItem[index];
                        return _buildRequestItem(context, item);
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildRequestItem(BuildContext context, AcceptedSwapItem item) {
    return BlocBuilder<FoodSwapBloc, FoodSwapState>(
      builder: (context, state) {
        if (state is RequestAcceptedLoadingState) {
          _isLoading = state.isLoading;
        }
        return FutureBuilder<DocumentSnapshot>(
          future: Collections.users.doc(item.uid).get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return _buildRequestItemSkeleton();
            }
            if (userSnapshot.hasError) {
              return _buildRequestItemSkeleton(
                errorMessage: "Error loading user details",
              );
            }
            final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
            final userName =
                "${userData?['firstName']} ${userData?['lastName']}";

            final userProfilePic = userData?['profilePicUrl'];
            final fcmToken = userData?['fcmToken'] ?? "";

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColor.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          left: 12,
                          right: 12,
                        ),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            border: Border.all(color: AppColor.lightGrey200),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: userProfilePic != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      userProfilePic,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Icon(
                                          Icons.person,
                                          color: AppColor.lightGrey200,
                                        );
                                      },
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    color: AppColor.lightGrey200,
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Swaped with: ${item.acceptedSwapItem ?? ""}",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.requestedOn} ${DateFormatHelper.ddmmyyyyString(item.pickupDate ?? "")}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Divider(
                        color: Colors.grey.shade200,
                        thickness: 2,
                        indent: 12,
                        endIndent: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          bottom: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: SaverOutlineButton(
                                  isLoading: _isLoading,
                                  text: AppLocalizations.of(context)!.accept,
                                  onPressed: () {
                                    final localizedMessages = {
                                      'hello':
                                          AppLocalizations.of(context)!.hello,
                                      'acceptFoodSwap': AppLocalizations.of(
                                        context,
                                      )!
                                          .iAcceptYourFoodSwap,
                                      'donateFoodMessage': AppLocalizations.of(
                                        context,
                                      )!
                                          .iWantToDonateMyFoodWithYou,
                                      'receiveFoodMessage': AppLocalizations.of(
                                        context,
                                      )!
                                          .iWantToReceiveFoodWithYou,
                                      'foodSwapAccepted': AppLocalizations.of(
                                        context,
                                      )!
                                          .foodSwapAccepted,
                                      'beneficiaryAccepted':
                                          AppLocalizations.of(
                                        context,
                                      )!
                                              .beneficiaryAccepted,
                                    };
                                    context.read<FoodSwapBloc>().add(
                                          AcceptedFoodSwapRequestEvent(
                                            swapId: item.swapedItemId ?? "",
                                            acceptedSwapItemId:
                                                item.acceptedSwapItemId ?? '',
                                            reciverUid: item.uid ?? "",
                                            fcmToken: fcmToken,
                                            communityBloc:
                                                context.read<CommunityBloc>(),
                                            context: context,
                                            localizedMessages:
                                                localizedMessages,
                                          ),
                                        );
                                  },
                                  borderColor: AppColor.primaryColor,
                                  textColor: AppColor.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: SaverOutlineButton(
                                  isLoading: state
                                      is FoodSwapRequestDeclinedLoadingState,
                                  text: AppLocalizations.of(context)!.decline,
                                  onPressed: () =>
                                      context.read<FoodSwapBloc>().add(
                                            DeclineFoodSwapEvent(
                                              reqId: item.reqId ?? 0,
                                              swapId: item.swapedItemId ?? "",
                                            ),
                                          ),
                                  borderColor: AppColor.red,
                                  textColor: AppColor.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRequestItemSkeleton({String? errorMessage}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    errorMessage != null
                        ? Text(
                            errorMessage,
                            style: TextStyle(color: AppColor.red),
                          )
                        : Container(
                            height: 20,
                            width: 150,
                            color: Colors.grey.shade200,
                          ),
                    const SizedBox(height: 8),
                    Container(
                      height: 15,
                      width: 100,
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
