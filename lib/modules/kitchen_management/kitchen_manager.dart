import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/date_compare.dart';
import 'package:saver_bbk_main/common_widget/empty_list.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/kitchen_management/add_item.dart';
import 'package:saver_bbk_main/modules/kitchen_management/bloc/kitchen_manager_bloc.dart';
import 'package:saver_bbk_main/modules/kitchen_management/widgets/food_expiry_tracker.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/widgets/item_sheets.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class KitchenManager extends StatefulWidget {
  final VoidCallback onBack;
  const KitchenManager({super.key, required this.onBack});

  @override
  State<KitchenManager> createState() => _KitchenManagerState();
}

class _KitchenManagerState extends State<KitchenManager> {
  String selectedFilter = "";
  List<Map<String, String>> shoppingList = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  List<Items> kitchenItems = [];
  bool isLoading = true;
  final FocusNode searchFocusNode = FocusNode();
  UserModel? userData;
  double percentage = 0.0;
  StreamSubscription? _userDataSubscription;
  List listNames = [];
  List<Items>? filteredItems;

  @override
  void initState() {
    super.initState();
    _setupUserDataStream();
    searchController.addListener(_onSearchChanged);
    searchFocusNode.addListener(_onSearchFocusChange);
  }

  void _onSearchFocusChange() {
    if (searchFocusNode.hasFocus && selectedFilter.isNotEmpty) {
      setState(() {
        selectedFilter = "";
      });
    }
  }

  Timer? _debounce;

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  void _setupUserDataStream() {
    setState(() {
      isLoading = true;
    });

    _userDataSubscription = Services.getUserDetails(uid: Services.uid).listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            userData = snapshot.docs.first.data();

            kitchenItems = userData?.kitchenItems ?? [];
            double addedCount =
                userData?.monthlyItemQuantityAddedCount?.toDouble() ?? 0.0;
            double removedCount =
                userData?.monthlyItemQuantityRemovedCount?.toDouble() ?? 1.0;
            percentage =
                (removedCount != 0) ? (addedCount / removedCount) * 100 : 0.0;
            isLoading = false;
          });
        } else {
          setState(() {
            kitchenItems = [];
            isLoading = false;
          });
        }
      },
      onError: (e) {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    searchFocusNode.removeListener(_onSearchFocusChange);
    searchFocusNode.dispose();
    _userDataSubscription?.cancel();
    super.dispose();
  }

  List<Items> filterItems(List<Items> items) {
    return items.where((item) {
      bool matchesFilter = true;
      DateTime expiredDate;
      if (item.expiredDate is Timestamp) {
        expiredDate = (item.expiredDate as Timestamp).toDate();
      } else if (item.expiredDate is DateTime) {
        expiredDate = item.expiredDate as DateTime;
      } else {
        return false;
      }
      int days = expiredDate.difference(DateTime.now()).inDays;
      if (selectedFilter.isNotEmpty) {
        if (selectedFilter == "Expired") {
          matchesFilter = days < 0;
        } else if (selectedFilter == "Expiring Soon") {
          matchesFilter = days >= 0 && days <= 2;
        } else if (selectedFilter == "Fresh") {
          matchesFilter = days >= 3;
        }
      }
      bool matchesSearch =
          searchQuery.isEmpty ||
          item.name!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddItem(isEdit: false),
              settings: RouteSettings(name: 'AddItem'),
            ),
          );
        },
        child: Icon(Icons.add, color: AppColor.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: saverAppBar(
        'Kitchen Manager',
        textColor: AppColor.white,
        iconColor: AppColor.white,
        context,
        isneedtopop: true,
        onpop: widget.onBack,
        iswhite: false,
      ),
      body: isLoading ? SaverLoader() : _buildContent(),
    );
  }

  Widget _buildContent() {
    filteredItems = filterItems(kitchenItems);

    return BlocListener<KitchenManagerBloc, KitchenManagerState>(
      listener: (context, state) {
        if (state is RemoveItemStateSuccess) {
          if (state.insideParentPage) {
            Navigator.pop(context);
          }
          SaverSnackBar.show(
            context: context,
            message: "Item removed",
            isTrue: true,
          );
        }
        if (state is RemoveItemStateError) {
          SaverSnackBar.show(
            context: context,
            message: "Failed to remove item",
            isTrue: false,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FoodExpiryTracker(),
            SizedBox(height: 10),
            _buildSearchBar(),
            SizedBox(height: 15),
            _buildFilterButtonsRow(),
            SizedBox(height: 20),
            _buildFilterTitle(filteredItems!),
            Expanded(
              child:
                  filteredItems!.isEmpty
                      ? EmptyList()
                      : _buildItemsList(filteredItems!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            focusNode: searchFocusNode,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColor.lightGrey200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColor.lightGrey200),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColor.lightGrey200),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColor.lightGrey200),
              ),
              suffixIcon:
                  searchQuery.isNotEmpty
                      ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey.shade600),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                      : Icon(Icons.search, color: Colors.grey.shade600),
              hintStyle: TextStyle(color: AppColor.lightGrey200),
              hintText: "search items",
            ),
            onTap: () {
              if (selectedFilter.isNotEmpty) {
                setState(() {
                  selectedFilter = "";
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButtonsRow() {
    return Row(
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildFilterButton(
            AppColor.red,
            "Expired",
            Icons.sentiment_neutral_outlined,
          ),
        ),
        Expanded(
          child: _buildFilterButton(
            AppColor.pointColor,
            "Expiring Soon",
            Icons.sentiment_satisfied_alt_outlined,
          ),
        ),
        Expanded(
          child: _buildFilterButton(
            AppColor.green,
            "Fresh",
            Icons.sentiment_very_satisfied_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTitle(List<Items> filteredItems) {
    return Text(
      selectedFilter.isEmpty && searchQuery.isEmpty
          ? "All Items"
          : searchQuery.isNotEmpty && selectedFilter.isNotEmpty
          ? "Search Results for '$searchQuery' in $selectedFilter Items"
          : searchQuery.isNotEmpty
          ? "Search Results for '$searchQuery'"
          : selectedFilter == "Expiring Soon"
          ? "Items $selectedFilter"
          : "$selectedFilter Items",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColor.black,
      ),
    );
  }

  Widget _buildItemsList(List<Items> filteredItems) {
    if (filteredItems.isEmpty) {
      return EmptyList();
    }

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(Items item) {
    DateTime expDate;
    if (item.expiredDate is Timestamp) {
      expDate = (item.expiredDate as Timestamp).toDate();
    } else if (item.expiredDate is DateTime) {
      expDate = item.expiredDate as DateTime;
    } else {
      expDate = DateTime.now();
    }

    String dateString = "${expDate.day}/${expDate.month}/${expDate.year}";
    int days = getDateDifferenceNumber(dateString);
    int daysLeft = days.abs();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Dismissible(
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            SmartListSheet().showListSelector(context, item);
            return false;
          }
          return true;
        },
        key: Key(item.id ?? item.expiredDate?.toIso8601String() ?? ""),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            context.read<KitchenManagerBloc>().add(
              RemoveItemEvent(
                itemId: item.id ?? "",
                beforeExpiry: !itemRemovedBeforeExpiry(item),
                itemCount: item.quantity ?? 0,
              ),
            );
          }
        },
        background: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                Text(
                  "Move to Shopping List",
                  style: TextStyle(color: AppColor.white),
                ),
              ],
            ),
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.trash, color: Colors.white, size: 25),
              Text("Remove from list", style: TextStyle(color: AppColor.white)),
            ],
          ),
        ),

        child: GestureDetector(
          onTap:
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => AddItem(
                        isEdit: true,
                        item: item,
                        dateString: dateString,
                      ),
                ),
              ),
          child: _buildItemCardContent(item, days, daysLeft),
        ),
      ),
    );
  }

  Widget _buildItemCardContent(Items item, int days, int daysLeft) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: AppColor.white,
                border: Border.all(color: AppColor.lightGrey200),
                borderRadius: BorderRadius.circular(16),
              ),
              child:
                  item.image == null || item.image == ""
                      ? Center(
                        child: Icon(Icons.image, color: AppColor.lightGrey200),
                      )
                      : CachedNetworkImage(
                        imageUrl: item.image ?? "",
                        placeholder: (context, url) => Icon(Icons.image),
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
                  children: [
                    Text(
                      item.name ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    _buildExpiryBadge(days, daysLeft),
                  ],
                ),
                _buildDateRow(item),
                _buildCategoryAndQuantityRow(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiryBadge(int days, int daysLeft) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:
            days <= 0
                ? AppColor.lightRed
                : days > 0 && days < 3
                ? AppColor.lightYellow
                : AppColor.greenshade,
      ),
      height: 27,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              days <= 0
                  ? Icons.sentiment_neutral_outlined
                  : days > 0 && days < 3
                  ? Icons.sentiment_satisfied_alt_outlined
                  : Icons.sentiment_very_satisfied_outlined,
              size: 14,
              color:
                  days <= 0
                      ? AppColor.red
                      : days > 0 && days < 3
                      ? AppColor.yellow
                      : AppColor.green,
            ),
            Text(
              "$daysLeft d",
              style: TextStyle(
                fontSize: 12,
                color:
                    days <= 0
                        ? AppColor.red
                        : days > 0 && days < 3
                        ? AppColor.yellow
                        : AppColor.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(Items item) {
    DateTime expDate;
    if (item.expiredDate is Timestamp) {
      expDate = (item.expiredDate as Timestamp).toDate();
    } else if (item.expiredDate is DateTime) {
      expDate = item.expiredDate as DateTime;
    } else {
      expDate = DateTime.now(); // Fallback
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.greenshade,
          child: loadsvg("assets/icons/expiry.svg"),
        ),
        Text(
          " Expiry Date: ${expDate.day}/${expDate.month}/${expDate.year}",
          style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
        ),
      ],
    );
  }

  Widget _buildCategoryAndQuantityRow(Items item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColor.lightblue,
                child: Icon(
                  size: 14,
                  Icons.task_alt_outlined,
                  color: AppColor.blue,
                ),
              ),
              Text(
                " Category: ${item.category != "" ? item.category : "N/A"}",
                style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
              ),
            ],
          ),
        ),
        SizedBox(width: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: AppColor.lightRed,
              child: Icon(size: 14, Icons.list_outlined, color: AppColor.red),
            ),
            Text(
              " Quantity: ${item.quantity}",
              style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterButton(Color textcolor, String text, IconData icondata) {
    bool isSelected = selectedFilter == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = selectedFilter == text ? "" : text;
        });
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? textcolor : AppColor.lightGrey200,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icondata,
                size: 18,
                color: isSelected ? textcolor : AppColor.lightGrey200,
              ),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? textcolor : AppColor.lightGrey200,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

itemRemovedBeforeExpiry(Items item) {
  DateTime expDate;
  if (item.expiredDate is Timestamp) {
    expDate = (item.expiredDate as Timestamp).toDate();
  } else if (item.expiredDate is DateTime) {
    expDate = item.expiredDate as DateTime;
  } else {
    expDate = DateTime.now();
  }

  final dateString = "${expDate.day}/${expDate.month}/${expDate.year}";
  final dayum = getDateDifferenceNumber(dateString);

  if (dayum >= 0) {
    return true;
  } else {
    return false;
  }
}
