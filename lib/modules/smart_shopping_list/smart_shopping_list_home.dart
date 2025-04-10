import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/helpers/date_format.dart';
import 'package:saver_bbk_main/models/smart_shopping_model.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/bloc/smart_shopping_bloc.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/shopping_list.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SmartShoppingHome extends StatefulWidget {
  const SmartShoppingHome({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  State<SmartShoppingHome> createState() => _SmartShoppingHomeState();
}

class _SmartShoppingHomeState extends State<SmartShoppingHome> {
  TextEditingController searchController = TextEditingController();
  TextEditingController listNameController = TextEditingController();
  bool _isLoading = false;
  String searchQuery = "";
  final FocusNode searchFocusNode = FocusNode();

  bool _isSubmitLocked = false;

  Timer? _debounce;

  List<SmartShoppingModel>? _allLists;
  List<SmartShoppingModel> _filteredLists = [];

  StreamSubscription? _listSubscription;

  @override
  void initState() {
    super.initState();

    _subscribeToListStream();
  }

  void _subscribeToListStream() {
    _listSubscription?.cancel();
    _listSubscription = Services.getSmartList().listen(
      (lists) {
        setState(() {
          _allLists = lists;
          _filterLists();
        });
      },
      onError: (error) {
        print("Error in stream: $error");
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    listNameController.dispose();
    searchFocusNode.dispose();
    _debounce?.cancel();
    _listSubscription?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query != searchQuery) {
        setState(() {
          searchQuery = query.trim().toLowerCase();
          _filterLists();
        });
      }
    });
  }

  void _filterLists() {
    if (_allLists == null) return;

    if (searchQuery.isEmpty) {
      _filteredLists = List.from(_allLists!);
    } else {
      _filteredLists =
          _allLists!
              .where(
                (list) =>
                    (list.listName?.toLowerCase() ?? "").contains(searchQuery),
              )
              .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        AppLocalizations.of(context)!.smartShoppingList,
        context,
        isneedtopop: true,
        iswhite: false,
        iconColor: AppColor.white,
        textColor: AppColor.white,
        onpop: widget.onBack,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          _showAddBottomSheet();
        },
        child: Icon(Icons.add, color: AppColor.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    return BlocListener<SmartShoppingBloc, SmartShoppingState>(
      listener: (context, state) {
        if (state is CreateNewSmartShoppingListLoadingState) {
          setState(() {
            _isLoading = true;
          });
        }
        if (state is CreateNewSmartShoppingListSuccessState) {
          setState(() {
            _isLoading = false;
            _isSubmitLocked = false;
          });
          Navigator.pop(context);
          listNameController.clear();

          _subscribeToListStream();

          SaverSnackBar.show(
            context: context,
            message: AppLocalizations.of(context)!.yourNewListHasBeenCreated,
            isTrue: true,
          );
        }
        if (state is CreateNewSmartShoppingListFailureState) {
          setState(() {
            _isLoading = false;
            _isSubmitLocked = false;
          });
          SaverSnackBar.show(
            context: context,
            message: "Failed to create new list",
            isTrue: false,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 18),
            _buildTitle(),
            SizedBox(height: 18),
            Expanded(child: _buildListCard()),
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
                  searchController.text.isNotEmpty
                      ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey.shade600),
                        onPressed: () {
                          searchController.clear();
                          _onSearchChanged("");
                        },
                      )
                      : Icon(Icons.search, color: Colors.grey.shade600),
              hintStyle: TextStyle(color: AppColor.lightGrey200),
              hintText: AppLocalizations.of(context)!.searchList,
            ),
            onChanged: _onSearchChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.shoppingLists,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (searchQuery.isNotEmpty)
          Text(
            "Showing results for \"$searchQuery\"",
            style: TextStyle(color: AppColor.lightGrey200, fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildListCard() {
    return _allLists == null
        ? StreamBuilder<List<SmartShoppingModel>>(
          stream: Services.getSmartList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SaverLoader();
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error loading lists"));
            }

            if (snapshot.data?.isEmpty ?? true) {
              return Center(child: Text("No shopping lists found"));
            }

            if (_allLists == null) {
              _allLists = snapshot.data;
              _filterLists();
            }

            return _buildListView();
          },
        )
        : _buildListView();
  }

  Widget _buildListView() {
    if (_filteredLists.isEmpty && searchQuery.isNotEmpty) {
      return Center(child: Text("No lists matching \"$searchQuery\""));
    }

    if (_filteredLists.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noShppingListsFound),
      );
    }

    return ListView.builder(
      itemCount: _filteredLists.length,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        SmartShoppingModel item = _filteredLists[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ShoppingList(
                        listId: item.listId ?? '',
                        listName: item.listName ?? '',
                      ),
                ),
              ).then((_) {
                _subscribeToListStream();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.lightGrey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.listName ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColor.lightblue,
                          child: Icon(
                            Icons.check_circle_outlined,
                            color: AppColor.blue,
                            size: 12,
                          ),
                        ),
                        Text(
                          " Created On: ${DateFormatHelper.ddmmyyyy(item.createdAt ?? DateTime.now())}",
                          style: TextStyle(
                            color: AppColor.lightGrey200,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    LinearProgressIndicator(
                      value:
                          item.items?.isEmpty ?? true
                              ? 0
                              : (item.items!
                                      .where((e) => e.status == "PR")
                                      .length /
                                  item.items!.length),
                      color: Colors.orange,
                      backgroundColor: AppColor.lightGrey,
                    ),
                    SizedBox(height: 6),
                    Text(
                      item.items?.isNotEmpty ?? false
                          ? "${item.items!.where((e) => e.status == "PR").length} of ${item.items!.length} items purchased"
                          : AppLocalizations.of(context)!.noItemsFound,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.lightGrey200,
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
  }

  _showAddBottomSheet() {
    _isSubmitLocked = false;
    listNameController.clear();

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.addShoppingList,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColor.lightGrey,
                      thickness: 1.5,
                      height: 1.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 14,
                        top: 14,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.listName,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 14,
                        top: 8,
                      ),
                      child: SaverTextField(
                        hintText: AppLocalizations.of(context)!.enterListName,
                        controller: listNameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                        bottom: 24,
                        left: 14,
                        right: 14,
                      ),
                      child: SaverButton(
                        text: AppLocalizations.of(context)!.saveChanges,
                        isLoading: _isLoading,
                        onPressed:
                            (_isLoading || _isSubmitLocked)
                                ? () {}
                                : () {
                                  if (listNameController.text.trim().isEmpty) {
                                    SaverSnackBar.show(
                                      context: context,
                                      message: "Please enter a list name",
                                      isTrue: false,
                                    );
                                    return;
                                  }

                                  setState(() {
                                    _isSubmitLocked = true;
                                  });

                                  setModalState(() {});

                                  context.read<SmartShoppingBloc>().add(
                                    CreateNewSmartShoppingEvent(
                                      listName: listNameController.text.trim(),
                                    ),
                                  );
                                },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
