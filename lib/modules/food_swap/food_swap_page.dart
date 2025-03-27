import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/empty_list.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/food_swap_model.dart';
import 'package:saver_bbk_main/modules/food_swap/food_swap_request.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final Stream<List<FoodSwapModel>> _userSwapListStream =
      Services.getUserSwapListStream();
  final Stream<List<FoodSwapModel>> _availableSwapsStream =
      Services.getAvialableSwapListStream();
  List<FoodSwapModel>? myListings;
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

  List<String> filterOptions = [
    "1 to 5 Km",
    "5 to 20 Km",
    "20 to 50 Km",
    "More than 50 Km",
  ];
  List<String> filterDateOptions = [
    "Today",
    "In 3 days",
    "In 1 week",
    "More than a week",
  ];
  int? selectedFilter;
  bool _isLocationSelected = false;
  bool _isExpireDateSelected = false;

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
              builder:
                  (context) =>
                      MyListingsPage(isEdit: false, items: FoodSwapModel()),
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
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true, // Allows the sheet to be taller
      backgroundColor: AppColor.white,
      builder: (context) {
        return StatefulBuilder(
          // Allows state updates within the bottom sheet
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "Filter by ",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isLocationSelected = !_isLocationSelected;
                                    _isExpireDateSelected = false;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 40,

                                  width: double.infinity,
                                  decoration: BoxDecoration(),
                                  child:
                                      _isLocationSelected
                                          ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 5,
                                                color: AppColor.primaryColor,
                                              ),

                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 9,
                                                      ),
                                                  child: Text("Location"),
                                                ),
                                              ),
                                            ],
                                          )
                                          : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 12,
                                                      ),
                                                  child: Text("Location"),
                                                ),
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExpireDateSelected =
                                        !_isExpireDateSelected;
                                    _isLocationSelected = false;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 40,

                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                  child:
                                      _isExpireDateSelected
                                          ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 5,
                                                color: AppColor.primaryColor,
                                              ),

                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 9,
                                                      ),
                                                  child: Text("Expiry Date"),
                                                ),
                                              ),
                                            ],
                                          )
                                          : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 12,
                                                      ),
                                                  child: Text("Expiry Date"),
                                                ),
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child:
                              _isLocationSelected
                                  ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(4, (index) {
                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              // Now state updates correctly
                                              selectedFilter = index;
                                            });
                                          },
                                          title: Text(
                                            filterOptions[index],
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Radio<int>(
                                            value: index,
                                            activeColor: AppColor.primaryColor,
                                            groupValue: selectedFilter,
                                            fillColor: WidgetStateProperty.all(
                                              AppColor.primaryColor,
                                            ),
                                            onChanged: (int? value) {
                                              setState(() {
                                                selectedFilter = value!;
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                  : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(4, (index) {
                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              // Now state updates correctly
                                              selectedFilter = index;
                                            });
                                          },
                                          title: Text(
                                            filterDateOptions[index],
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Radio<int>(
                                            value: index,
                                            activeColor: AppColor.primaryColor,
                                            groupValue: selectedFilter,
                                            fillColor: WidgetStateProperty.all(
                                              AppColor.primaryColor,
                                            ),
                                            onChanged: (int? value) {
                                              setState(() {
                                                selectedFilter = value!;
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SaverOutlineButton(
                          text: "Clear All",
                          onPressed: () {
                            setState(() {
                              _isExpireDateSelected = false;
                              _isLocationSelected = false;
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: SaverButton(
                          text: "Apply",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMyListingsTab() {
    return StreamBuilder<List<FoodSwapModel>>(
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
        myListings = List.from(snapshot.data!);
        if (_searchController.text.isNotEmpty) {
          myListings?.removeWhere(
            (item) =>
                !(item.name!.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                )),
          );
        }
        return ListView.separated(
          itemCount: myListings?.length ?? 0,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = myListings![index];
            return _buildMyListingCard(item, index);
          },
        );
      },
    );
  }

  Widget _buildAvailableSwapsTab() {
    return StreamBuilder<List<FoodSwapModel>>(
      stream: _availableSwapsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SaverLoader();
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return EmptyList(
            message: "No available swaps",
            subMessage: "Check back later for new listings",
          );
        }
        final availableSwaps = snapshot.data!;
        if (_searchController.text.isNotEmpty) {
          availableSwaps.removeWhere(
            (item) =>
                !(item.name!.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                )),
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

  Widget _buildMyListingCard(FoodSwapModel items, int index) {
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
            if (items.status == "P") _buildPendingRequestsSection(index),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableSwapCard(FoodSwapModel items) {
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
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FoodSwapRequest(items: items),
                    ),
                  );
                },
                borderColor: AppColor.primaryColor,
                textColor: AppColor.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetailsRow(FoodSwapModel items, {required bool isPending}) {
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
              _buildItemHeaderRow(items),
              _buildExpiryDateRow(items),
              _buildLocationAndQuantityRow(items),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemHeaderRow(FoodSwapModel items) {
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
            color:
                items.status == "P" ? AppColor.lightYellow : AppColor.lightblue,
          ),
          height: 27,
          child: Center(
            child: Text(
              items.status == "P" ? "Pending" : "Accepted",
              style: TextStyle(
                fontSize: 12,
                color: items.status == "P" ? AppColor.yellow : AppColor.blue,
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
          " Expiry Date: ${DateFormatHelper.ddmmyyyy(items.expiredDate ?? DateTime.now())}",
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

  Widget _buildPendingRequestsSection(int index) {
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
              text: "${myListings![index].requests?.length} Requests Pending",
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
