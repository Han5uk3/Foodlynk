import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/date_compare.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/kitchen_management/add_item.dart';
import 'package:saver_bbk_main/modules/kitchen_management/bloc/kitchen_manager_bloc.dart';
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
  Map<String, dynamic> monthlyStats = {
    'totalAdded': 0,
    'removedBeforeExpiry': 0,
    'percentage': 0,
  };
  final FocusNode searchFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _fetchUserData();
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

  void _fetchUserData() async {
    try {
      final snapshot = await Services.getUserDetails().first;
      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first.data();
        setState(() {
          kitchenItems = userData.kitchenItems ?? [];

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    searchFocusNode.removeListener(_onSearchFocusChange);
    searchFocusNode.dispose();
    super.dispose();
  }

  List<Items> filterItems(List<Items> items) {
    return items.where((item) {
      bool matchesFilter = true;
      int days = getDateDifferenceNumber(
        "${item.expiredDate.day}/${item.expiredDate.month}/${item.expiredDate.year}",
      );

      if (selectedFilter.isNotEmpty) {
        if (selectedFilter == "Expired") {
          matchesFilter = days < 0;
        } else if (selectedFilter == "Expiring Soon") {
          matchesFilter = days >= 0 && days < 3;
        } else if (selectedFilter == "Fresh") {
          matchesFilter = days >= 3;
        }
      }

      bool matchesSearch =
          searchQuery.isEmpty || item.name.toLowerCase().contains(searchQuery);

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
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => AddItem(isEdit: false),

                  settings: RouteSettings(name: 'AddItem'),
                ),
              )
              .then((_) => _fetchUserData());
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
    final List<Items> filteredItems = filterItems(kitchenItems);

    return BlocListener<KitchenManagerBloc, KitchenManagerState>(
      listener: (context, state) {
        if (state is RemoveItemStateSuccess) {
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: CustomPaint(
                painter: DiagonalBackgroundPainter(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.rotate(
                            angle: -1.57,
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: CircularProgressIndicator(
                                value: monthlyStats['percentage'] / 100,
                                strokeWidth: 8,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColor.pointColor,
                                ),
                                backgroundColor: Color.fromARGB(
                                  130,
                                  249,
                                  219,
                                  116,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "${monthlyStats['percentage']}%",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.pointColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You've consumed ${monthlyStats['percentage']}% of your food before expiry this month!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${monthlyStats['removedBeforeExpiry']} items used / ${monthlyStats['totalAdded']} items added",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.lightGrey200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildSearchBar(),
            SizedBox(height: 15),
<<<<<<< Updated upstream
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 15,
=======
            _buildFilterButtonsRow(),
            SizedBox(height: 20),
            _buildFilterTitle(filteredItems),
            Expanded(
              child:
                  filteredItems.isEmpty
                      ? _buildEmptyState()
                      : _buildItemsList(filteredItems),
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
          ? "Search: '$searchQuery' in $selectedFilter Items"
          : searchQuery.isNotEmpty
          ? "Search: '$searchQuery'"
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 48, color: AppColor.lightGrey200),
          SizedBox(height: 12),
          Text(
            searchQuery.isNotEmpty
                ? "No items match your search"
                : selectedFilter.isNotEmpty
                ? "No ${selectedFilter.toLowerCase()} items found"
                : "No items found",
            style: TextStyle(fontSize: 16, color: AppColor.lightGrey200),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(List<Items> filteredItems) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return _buildItemCard(filteredItems[index]);
      },
    );
  }

  Widget _buildItemCard(Items item) {
    int days = getDateDifferenceNumber(
      "${item.expiredDate.day}/${item.expiredDate.month}/${item.expiredDate.year}",
    );
    int daysLeft = days.abs();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Dismissible(
        key: Key(item.name + item.expiredDate.toIso8601String()),
        direction: DismissDirection.horizontal,
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
>>>>>>> Stashed changes
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
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
          } else {
            context.read<KitchenManagerBloc>().add(
              RemoveItemEvent(itemId: item.id),
            );
          }
        },
        child: GestureDetector(
          onTap:
              () => Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder:
                          (context) => AddItem(
                            isEdit: true,
                            dateString:
                                "${item.expiredDate.day}/${item.expiredDate.month}/${item.expiredDate.year}",
                          ),
                    ),
                  )
                  .then((_) => _fetchUserData()),
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
                  children: [
                    Text(
                      item.name,
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

<<<<<<< Updated upstream
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No kitchen items found');
                  }

                  // Directly access the UserModel object
                  final userData = snapshot.data!.docs.first.data();

                  // Check for null kitchen items
                  final List<Items> kitchenItems = userData.kitchenItems ?? [];
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    itemCount: kitchenItems.length,
                    itemBuilder: (context, index) {
                      Items items = kitchenItems[index];
                      int days = getDateDifferenceNumber(
                        "${items.expiredDate.day}/${items.expiredDate.month}/${items.expiredDate.year}",
                      );
                      int daysLeft = days.abs();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Dismissible(
                          key: Key(
                            items.name + items.expiredDate.toIso8601String(),
                          ),
                          direction: DismissDirection.horizontal,
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
                                spacing: 3,
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
                              spacing: 3,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.trash,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                Text(
                                  "Remove from list",
                                  style: TextStyle(color: AppColor.white),
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              itemRemovedBeforeExpiry(userData, index)
                                  ?
                                  // add bloc code to increment the item count
                                  log(
                                    "Item removed before expiry ${itemRemovedBeforeExpiry(userData, index)}",
                                  )
                                  : log(
                                    "Item removed before expiry ${itemRemovedBeforeExpiry(userData, index)}",
                                  );
                            } else {
                              // add to shopping cart;
                            }
                          },
                          child: GestureDetector(
                            onTap:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => AddItem(
                                          isEdit: true,
                                          dateString:
                                              "${items.expiredDate.day}/${items.expiredDate.month}/${items.expiredDate.year}",
                                        ),
                                  ),
                                ),
                            child: Container(
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        border: Border.all(
                                          color: AppColor.lightGrey200,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.image,
                                          color: AppColor.lightGrey200,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 2,
                                      mainAxisSize: MainAxisSize.min,

                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              items.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                right: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color:
                                                    days < 0
                                                        ? AppColor.lightRed
                                                        : days >= 0 && days < 3
                                                        ? AppColor.lightYellow
                                                        : AppColor.greenshade,
                                              ),
                                              height: 27,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 9,
                                                      vertical: 3,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      days < 0
                                                          ? Icons
                                                              .sentiment_neutral_outlined
                                                          : days >= 0 &&
                                                              days < 3
                                                          ? Icons
                                                              .sentiment_satisfied_alt_outlined
                                                          : Icons
                                                              .sentiment_very_satisfied_outlined,
                                                      size: 14,
                                                      color:
                                                          days < 0
                                                              ? AppColor.red
                                                              : days >= 0 &&
                                                                  days < 3
                                                              ? AppColor.yellow
                                                              : AppColor.green,
                                                    ),
                                                    Text(
                                                      "$daysLeft d",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            days < 0
                                                                ? AppColor.red
                                                                : days >= 0 &&
                                                                    days < 3
                                                                ? AppColor
                                                                    .yellow
                                                                : AppColor
                                                                    .green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundColor:
                                                  AppColor.greenshade,
                                              child: loadsvg(
                                                "assets/icons/expiry.svg",
                                              ),
                                            ),
                                            Text(
                                              " Expiry Date: ${items.expiredDate.day}/${items.expiredDate.month}/${items.expiredDate.year}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColor.lightGrey200,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IntrinsicWidth(
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 12,
                                                    backgroundColor:
                                                        AppColor.lightblue,
                                                    child: Icon(
                                                      size: 14,
                                                      Icons.task_alt_outlined,
                                                      color: AppColor.blue,
                                                    ),
                                                  ),
                                                  Text(
                                                    " Category: ${items.category != "" ? items.category : "N/A"}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          AppColor.lightGrey200,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),

                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor:
                                                      AppColor.lightRed,
                                                  child: Icon(
                                                    size: 14,
                                                    Icons.list_outlined,
                                                    color: AppColor.red,
                                                  ),
                                                ),
                                                Text(
                                                  " Quantity: ${items.quantity}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        AppColor.lightGrey200,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
=======
  Widget _buildExpiryBadge(int days, int daysLeft) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:
            days < 0
                ? AppColor.lightRed
                : days >= 0 && days < 3
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
              days < 0
                  ? Icons.sentiment_neutral_outlined
                  : days >= 0 && days < 3
                  ? Icons.sentiment_satisfied_alt_outlined
                  : Icons.sentiment_very_satisfied_outlined,
              size: 14,
              color:
                  days < 0
                      ? AppColor.red
                      : days >= 0 && days < 3
                      ? AppColor.yellow
                      : AppColor.green,
            ),
            Text(
              "$daysLeft d",
              style: TextStyle(
                fontSize: 12,
                color:
                    days < 0
                        ? AppColor.red
                        : days >= 0 && days < 3
                        ? AppColor.yellow
                        : AppColor.green,
>>>>>>> Stashed changes
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(Items item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColor.greenshade,
          child: loadsvg("assets/icons/expiry.svg"),
        ),
        Text(
          " Expiry Date: ${item.expiredDate.day}/${item.expiredDate.month}/${item.expiredDate.year}",
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

itemRemovedBeforeExpiry(UserModel userData, index) {
  final Items kitchenItems = userData.kitchenItems![index];
  final dayum = getDateDifferenceNumber(
    "${kitchenItems.expiredDate.day}/${kitchenItems.expiredDate.month}/${kitchenItems.expiredDate.year}",
  );

  if (dayum >= 0) {
    return true;
  } else {
    return false;
  }
}

class DiagonalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    Path topLeftPath =
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width * 0.53, 0)
          ..lineTo(size.width * 0.76, size.height)
          ..lineTo(0, size.height)
          ..close();

    paint.color = Color.fromARGB(100, 246, 231, 178);
    canvas.drawPath(topLeftPath, paint);

    Path bottomRightPath =
        Path()
          ..moveTo(size.width, 0)
          ..lineTo(size.width * 0.53, 0)
          ..lineTo(size.width * 0.76, size.height)
          ..lineTo(size.width, size.height)
          ..close();

    paint.color = Color.fromARGB(200, 246, 231, 178);
    canvas.drawPath(bottomRightPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
