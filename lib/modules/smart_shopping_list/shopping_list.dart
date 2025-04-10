import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/models/smart_shopping_model.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/bloc/smart_shopping_bloc.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/widgets/item_sheets.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingList extends StatefulWidget {
  final String listId;
  String? listName;
  ShoppingList({super.key, required this.listId, this.listName = ""});
  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List? allItems;
  List? purchaseItems;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartShoppingBloc, SmartShoppingState>(
      builder: (context, state) {
        if (state is ListNameChangedSuccessState) {
          widget.listName = state.listnewName;
        }
        return Scaffold(
          appBar: saverAppBar(
            widget.listName ?? "",
            context,
            isneedtopop: true,
            iswhite: true,
            actions: [
              IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: () {
                  SmartListSheet().showEditBottomSheet(
                    context,
                    false,
                    false,
                    listId: widget.listId,
                  );
                },
              ),
            ],
          ),
          body: Padding(padding: const EdgeInsets.all(14), child: _buildBody()),
          floatingActionButton: FloatingActionButton(
            elevation: 3,
            backgroundColor: AppColor.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed:
                () => SmartListSheet().showEditBottomSheet(
                  context,
                  true,
                  false,
                  listId: widget.listId,
                ),
            child: Icon(Icons.add, color: AppColor.white, size: 32),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _buildBody() {
    return BlocListener<SmartShoppingBloc, SmartShoppingState>(
      listener: (context, state) {},
      child: Column(
        children: [
          _buildTabSelector(),
          SizedBox(height: 20),
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Expanded(
      child: IndexedStack(
        index: _tabController.index,
        children: [_buildAllListItems(), _buildPurchasedListItems()],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              AppLocalizations.of(context)!.all,
              AppColor.yellow600,
              AppColor.lightYellow,
              0,
            ),
          ),
          Expanded(
            child: _buildTabButton(
              AppLocalizations.of(context)!.purchased,
              AppColor.primaryColor,
              AppColor.lightGreen100,
              1,
            ),
          ),
        ],
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

  Widget _buildAllListItems() {
    return StreamBuilder<List<SmartShoppingModel>>(
      stream: Services.fetchSmartListAllItems(widget.listId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SaverLoader();
        }
        if (snapshot.data?.isEmpty ?? false) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noItemsFound,
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        allItems =
            snapshot.data!
                .expand(
                  (model) =>
                      model.items
                          ?.where((i) => i.status == "AL")
                          .where((item) => item != null) ??
                      [],
                )
                .toList();
        purchaseItems =
            snapshot.data!
                .expand(
                  (model) =>
                      model.items
                          ?.where((i) => i.status == "PR")
                          .where((item) => item != null) ??
                      [],
                )
                .toList();

        if (allItems == null || allItems!.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noItemsInTheList,
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: allItems?.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Items items = allItems?[index];
            if (items == null) return SizedBox();
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap:
                    () => SmartListSheet().showEditBottomSheet(
                      context,
                      true,
                      true,
                      items: items,
                      listId: widget.listId,
                    ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.lightGrey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextStyle(fontWeight: FontWeight.w700),
                            text: items.name,
                            children: [
                              WidgetSpan(
                                child: Transform.translate(
                                  offset: Offset(0, -5),
                                  child: Text(
                                    ' x${items.quantity} ${items.unit}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.lightGrey200,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Icon(
                          Icons.drag_indicator_outlined,
                          color: AppColor.lightGrey200,
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
    );
  }

  Widget _buildPurchasedListItems() {
    if (purchaseItems == null || purchaseItems!.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noPurchasedItems,
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      itemCount: purchaseItems?.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Items items = purchaseItems?[index];
        if (items == null) return SizedBox();
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.lightGrey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontWeight: FontWeight.w700),
                      text: items.name,
                      children: [
                        WidgetSpan(
                          child: Transform.translate(
                            offset: Offset(0, -5),
                            child: Text(
                              ' x${items.quantity} ${items.unit}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.lightGrey200,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Icon(
                    Icons.check_circle_outline_outlined,
                    color: AppColor.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
