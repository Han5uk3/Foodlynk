import 'dart:io';
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
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/food_swap_model.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/food_swap/bloc/food_swap_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class MyListingsPage extends StatefulWidget {
  final bool isEdit;
  final FoodSwapModel? items;

  const MyListingsPage({super.key, required this.isEdit, this.items});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  DateTime selectedExpiryDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
        widget.isEdit ? "My Listing" : "Add New Item",
        context,
        isneedtopop: false,
        actions:
            widget.isEdit
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
                      onPressed:
                          () => _showDeleteFoodSwap(context, widget.items!),
                    ),
                  ),
                ]
                : [],
        bottom:
            widget.isEdit
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
                            tabs: const [
                              Tab(text: "Food Details"),
                              Tab(text: "Requests"),
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
              message: "Food Swap Success",
              isTrue: true,
            );
          } else if (state is FoodSwapUpdateSuccessState) {
            Navigator.of(context).pop();
            SaverSnackBar.show(
              context: context,
              message: "Food Swap Updated Successfully",
              isTrue: true,
            );
          } else if (state is DeleteFromFoodSwapSuccessState) {
            SaverSnackBar.show(
              context: context,
              message: "Food Swap Deleted Successfully",
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
        child:
            widget.isEdit
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
              title: const Text(
                "Delete Item",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                "Are you sure you want to delete this ${items.name} Item? This action cannot be undone.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                TextButton(
                  onPressed:
                      isLoadingDelete
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
                  child:
                      isLoadingDelete
                          ? SaverLoader()
                          : Text(
                            "Delete",
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
  final List<String> category = [
    "Dairy",
    "Meat",
    "Oils",
    "Poultry",
    "Fruits",
    "Vegetables",
    "Seafood",
  ];

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
    final Items item = Items(
      id: widget.items.id,
      name: nameController.text,
      quantity: numberOfQuantity,
      unit: selectedUnit ?? "",
      category: selectedCategory,
      expiredDate: selectedExpiryDate,
    );

    if (widget.isEditable) {
      context.read<FoodSwapBloc>().add(UpdateItemInFoodSwapEvent(item: item));
    } else {
      context.read<FoodSwapBloc>().add(AddItemToFoodSwapEvent(item: item));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Label(text: "Item Name"),
            const SizedBox(height: 10),
            SaverTextField(
              hintText: "Garlic Bread",
              controller: nameController,
            ),
            const SizedBox(height: 15),
            const Label(text: "Quantity"),
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
                    hint: "Choose",
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
            const Text(
              "Expiry Date",
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
            const Text(
              "Upload Image",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
                  ImagePickerButton(isFood: false, onImageSelected: _setImage),
              ],
            ),
          ],
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
              text: widget.isEditable ? "Save Changes" : "Add to Listing",
              onPressed: isButtonLoading ? () {} : _saveChanges,
            );
          },
        ),
      ),
    );
  }
}

class RequestsDetails extends StatelessWidget {
  final FoodSwapModel foodSwapModel;
  const RequestsDetails({super.key, required this.foodSwapModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
        child: StreamBuilder<List<AcceptedSwapItem>>(
          stream: Services.getRequestSwapListStream(foodSwapModel.id ?? ""),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return Text("No requests found.");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SaverLoader();
            }
            if (snapshot.hasError) {
              return Text("Error fetching requests: ${snapshot.error}");
            }

            if (snapshot.data!.isEmpty) {
              return EmptyList(
                message: "No requests found.",
                subMessage: "Check back later for new requests",
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
    );
  }

  Widget _buildRequestItem(BuildContext context, AcceptedSwapItem item) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(color: AppColor.lightGrey200),
                      borderRadius: BorderRadius.circular(50),
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Jonnathan",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Icon(
                              Icons.messenger_outline,
                              color: AppColor.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Requested on ${DateFormatHelper.ddmmyyyyString(item.pickupDate ?? "")}",
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
                            text: "Accept",
                            onPressed: () {},
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
                            text: "Decline",
                            onPressed: () {},
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
      ),
    );
  }
}
