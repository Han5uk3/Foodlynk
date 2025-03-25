import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/empty_list.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/food_swap/my_listings_page.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class FoodSwapPage extends StatefulWidget {
  const FoodSwapPage({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  State<FoodSwapPage> createState() => _FoodSwapPageState();
}

class _FoodSwapPageState extends State<FoodSwapPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isPending = true;
  final TextEditingController _searchController = TextEditingController();
  final Stream<List<DocumentSnapshot>> _userSwapListStream =
      Services.getUserSwapListStream();
  final Stream<List<DocumentSnapshot>> _availableSwapsStream =
      Services.getAvialableSwapListStream();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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
              builder: (context) => MyListingsPage(isEdit: false),
            ),
          );
        },
        child: Icon(Icons.add, color: AppColor.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: saverAppBar(
        "Food Swap",
        context,
        textColor: AppColor.white,
        iconColor: AppColor.white,
        iswhite: false,
        isneedtopop: true,
        onpop: widget.onBack,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          SizedBox(height: 6),
          _buildSearchField(),
          SizedBox(height: 20),
          _buildTabSelector(),
          SizedBox(height: 20),
          _buildSectionHeader(),
          SizedBox(height: 20),
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
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
        suffixIcon: Icon(Icons.search, color: Colors.grey.shade600),
        hintStyle: TextStyle(color: AppColor.lightGrey200),
        hintText: "search items",
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              "My Listings",
              AppColor.appbarColor,
              AppColor.lightAppbarColor,
              0,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              "Available Swaps",
              AppColor.green500,
              AppColor.lightGreen100,
              1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _tabController.index == 0 ? "My Listings" : "Available Swaps",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: _showFilterDialog,
          child: Icon(Icons.filter_list),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child: IndexedStack(
        index: _tabController.index,
        children: [_buildMyListingsTab(), _buildAvailableSwapsTab()],
      ),
    );
  }

  Widget _buildTabButton(
    String text,
    Color textColor,
    Color backgroundColor,
    int index,
  ) {
    bool isSelected = _tabController.index == index;

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Container(
        height: 45,
        margin: EdgeInsets.only(right: index == 0 ? 5 : 0),
        decoration: BoxDecoration(
          color: isSelected ? backgroundColor : AppColor.white,
          border: Border.all(
            color: isSelected ? textColor : AppColor.lightGrey200,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? textColor : AppColor.lightGrey200,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showBottomSheet(
      backgroundColor: AppColor.white,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text("Filter by ", style: TextStyle(fontSize: 16)),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(child: Text("Location")),
                          ),
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(child: Text("Expiry Date")),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Column(children: [])),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyListingsTab() {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: _userSwapListStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SaverLoader();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return EmptyList(
            message: "No food swap listings available",
            subMessage: "Tap the + button to create a new listing",
          );
        }

        final myListings =
            snapshot.data!
                .map((doc) => Items.fromMap(doc.data() as Map<String, dynamic>))
                .toList();

        if (_searchController.text.isNotEmpty) {
          myListings.removeWhere(
            (item) =>
                !(item.name?.toLowerCase().contains(
                      _searchController.text.toLowerCase(),
                    ) ??
                    false),
          );
        }

        return ListView.separated(
          itemCount: myListings.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = myListings[index];
            return _buildMyListingCard(item);
          },
        );
      },
    );
  }

  Widget _buildAvailableSwapsTab() {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: _availableSwapsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SaverLoader();
        }

        if (snapshot.hasError) {
          log("Error loading data: ${snapshot.error}");
          return const Center(child: Text("Error loading data"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return EmptyList(
            message: "No available swaps",
            subMessage: "Check back later for new listings",
          );
        }

        final availableSwaps =
            snapshot.data!
                .map((doc) => Items.fromMap(doc.data() as Map<String, dynamic>))
                .toList();

        if (_searchController.text.isNotEmpty) {
          availableSwaps.removeWhere(
            (item) =>
                !(item.name?.toLowerCase().contains(
                      _searchController.text.toLowerCase(),
                    ) ??
                    false),
          );
        }

        return ListView.separated(
          itemCount: availableSwaps.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = availableSwaps[index];
            return _buildAvailableSwapCard(item);
          },
        );
      },
    );
  }

  Widget _buildMyListingCard(Items items) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyListingsPage(isEdit: true, items: items),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildItemDetailsRow(items, isPending: true),
            if (isPending) _buildPendingRequestsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableSwapCard(Items items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildItemDetailsRow(items, isPending: false),
          Divider(
            color: Colors.grey.shade200,
            thickness: 2,
            indent: 12,
            endIndent: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: SizedBox(
              width: double.infinity,
              child: SaverOutlineButton(
                text: "Request Swap",
                onPressed: () {},
                borderColor: AppColor.green,
                textColor: AppColor.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetailsRow(Items items, {required bool isPending}) {
    return Row(
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
            color: isPending ? AppColor.lightYellow : AppColor.lightblue,
          ),
          height: 27,
          child: Center(
            child: Text(
              isPending ? "pending" : "available",
              style: TextStyle(
                fontSize: 12,
                color: isPending ? AppColor.yellow : AppColor.blue,
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

  Widget _buildPendingRequestsSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Divider(
          color: Colors.grey.shade200,
          thickness: 2,
          indent: 12,
          endIndent: 12,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
          child: SizedBox(
            width: double.infinity,
            child: SaverOutlineButton(
              text: "2 Requests Pending",
              onPressed: () {},
              borderColor: AppColor.yellow600,
              textColor: AppColor.yellow600,
            ),
          ),
        ),
      ],
    );
  }
}
