import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_selector/number_selector.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/kitchen_management/add_item.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/bloc/smart_shopping_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class SmartListSheet {
  void showEditBottomSheet(
    BuildContext context,
    bool isItem,
    bool isView, {
    Items? items,
    String? listId,
    bool? isFromInsideItem,
    bool? isFromKitchen,
  }) {
    final TextEditingController itemNameController = TextEditingController(
      text: items?.name ?? '',
    );
    int quantity = items?.quantity ?? 1;

    List<String> units = ["Kg", "Pcs", "ml", "Ltr", "gm", "Nos"];
    String selectedUnit = items?.unit ?? "Pcs";

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      isDismissible: false,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BlocListener<SmartShoppingBloc, SmartShoppingState>(
            listener: (context, state) {
              if (state is NewItemAddedToListSuccessState) {
                Navigator.pop(context);
                SaverSnackBar.show(
                  context: context,
                  message: "Item added successfully",
                  isTrue: true,
                );
              }
              if (state is NewItemAddedToListFailureState) {
                SaverSnackBar.show(
                  context: context,
                  message: state.errorMessage,
                  isTrue: false,
                );
              }
              if (state is PurchasedItemSuccessState) {
                Navigator.pop(context);
                Navigator.pop(context);
                SaverSnackBar.show(
                  context: context,
                  message: "Item purchased successfully",
                  isTrue: true,
                );
              }
              if (state is PurchasedItemFailureState) {
                SaverSnackBar.show(
                  context: context,
                  message: state.errorMessage,
                  isTrue: false,
                );
              }
              if (state is MovingItemSuccessState) {
                Navigator.pop(context);
                Navigator.pop(context);
                if (state.isFromParentSide) Navigator.pop(context);
                SaverSnackBar.show(
                  context: context,
                  message: "Item moved successfully",
                  isTrue: true,
                );
              }
              if (state is MovingItemFailureState) {
                SaverSnackBar.show(
                  context: context,
                  message: state.errorMessage,
                  isTrue: false,
                );
              }
              if (state is ListNameChangedSuccessState) {
                Navigator.pop(context);
                SaverSnackBar.show(
                  context: context,
                  message: "List name changed successfully",
                  isTrue: true,
                );
              }
              if (state is ListNameChangedFailureState) {
                SaverSnackBar.show(
                  context: context,
                  message: state.errorMessage,
                  isTrue: false,
                );
              }
            },
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isItem
                                ? isView
                                    ? items?.name ?? "N/A"
                                    : "Add New Item"
                                : "Edit Shopping List",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
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

                    // Item Name or List Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Label(text: isItem ? "Item Name" : "List Name"),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: (isFromKitchen ?? false) ? true : isView,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: SaverTextField(
                          hintText:
                              isItem ? "Enter Item Name" : "Weekly Grocery",
                          controller: itemNameController,
                        ),
                      ),
                    ),

                    // Quantity & Unit Section (Only for items)
                    if (isItem) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text("Quantity", style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            // Unit Dropdown
                            IntrinsicWidth(
                              child: SaverDropdown(
                                items: units,
                                selectedItem: selectedUnit,
                                hint: "Choose",
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => selectedUnit = value);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 12),
                            // Quantity Selector
                            Expanded(
                              child: NumberSelector.plain(
                                hasBorder: true,
                                showMinMax: false,
                                min: 1,
                                iconColor: Colors.grey.shade500,
                                borderRadius: 6,
                                borderColor: Colors.grey.shade300,
                                backgroundColor: AppColor.white,
                                current: quantity,
                                onUpdate:
                                    (newValue) => setState(() {
                                      quantity = newValue;
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Note (For View mode only)
                    if (isView)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Text(
                          "Note: When an item is purchased, it will be moved to the kitchen manager for tracking!",
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: AppColor.primaryColor),
                        ),
                      ),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 24,
                      ),
                      child: BlocBuilder<SmartShoppingBloc, SmartShoppingState>(
                        builder: (context, state) {
                          return isItem
                              ? isView
                                  ? Row(
                                    children: [
                                      Expanded(
                                        child: SaverButton(
                                          text: "Purchased",
                                          isLoading:
                                              state
                                                  is PurchasedItemLoadingState,
                                          onPressed:
                                              () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => AddItem(
                                                        isEdit: false,
                                                        item: items,
                                                        listId: listId,
                                                        isFromSmartList: true,
                                                      ),
                                                ),
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: SaverButton(
                                          text: "Remove from List",
                                          onPressed: () {
                                            // Uncomment when you implement remove functionality
                                            // context.read<SmartShoppingBloc>().add(
                                            //   RemoveItemSmartShoppingEvent(
                                            //     listId: listId ?? "",
                                            //     itemId: items?.id ?? "",
                                            //   ),
                                            // );
                                          },
                                          color: AppColor.red,
                                        ),
                                      ),
                                    ],
                                  )
                                  : SaverButton(
                                    text:
                                        (isFromKitchen ?? false)
                                            ? "Move to Shopping List"
                                            : "Add Item",
                                    isLoading:
                                        state
                                            is NewItemAddedToListLoadingState ||
                                        state is MovingItemLoadingState,
                                    onPressed:
                                        () =>
                                            (isFromKitchen ?? false)
                                                ? context
                                                    .read<SmartShoppingBloc>()
                                                    .add(
                                                      MoveFromKitchenToSmartListEvent(
                                                        listId: listId ?? "",
                                                        item: Items(
                                                          id: items?.id ?? "",
                                                          name:
                                                              items?.name ?? "",
                                                          quantity: quantity,
                                                          unit: selectedUnit,
                                                        ),
                                                        isFromParentSide:
                                                            isFromInsideItem ??
                                                            false,
                                                      ),
                                                    )
                                                : context
                                                    .read<SmartShoppingBloc>()
                                                    .add(
                                                      AddNewItemSmartShoppingEvent(
                                                        listId: listId ?? "",
                                                        itemName:
                                                            itemNameController
                                                                .text
                                                                .trim(),
                                                        itemQuantity: quantity,
                                                        itemUnit: selectedUnit,
                                                      ),
                                                    ),
                                  )
                              : SaverButton(
                                text: "Save Changes",
                                isLoading: state is ListNameChangedLoadingState,
                                onPressed:
                                    () => context.read<SmartShoppingBloc>().add(
                                      UpdateSmartShopingListNameEvent(
                                        newName: itemNameController.text.trim(),
                                        listId: listId ?? "",
                                      ),
                                    ),
                              );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  showListSelector(context, Items item, {bool isFromParentSheet = false}) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StreamBuilder<List<Map<String, String>>>(
            stream: Services.getUserSmartList(),
            builder: (context, snapshot) {
              List<String> listNames =
                  snapshot.data
                      ?.map((item) => item['listName'] ?? '')
                      .toList() ??
                  [];
              Map<String, String> listMap = {
                for (var item in snapshot.data ?? [])
                  item['listName'] ?? "": item['listId'] ?? "",
              };
              String? selectedListName =
                  listNames.isNotEmpty ? listNames.first : null;
              return StatefulBuilder(
                builder:
                    (context, insidesetState) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 12,
                                right: 12,
                                bottom: 6,
                                top: 12,
                              ),
                              child: Text(
                                item.name!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
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
                        Divider(color: AppColor.lightGrey, thickness: 2),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  "Select a list",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 10),
                              SaverDropdown(
                                items: listNames,
                                selectedItem: selectedListName ?? "",
                                isLoading:
                                    snapshot.connectionState ==
                                    ConnectionState.waiting,
                                onChanged: (value) {
                                  insidesetState(() {
                                    selectedListName = value!;
                                  });
                                },
                              ),
                              SizedBox(height: 15),
                              SaverButton(
                                text: "Add to list",
                                onPressed: () {
                                  if (selectedListName != null) {
                                    String? selectedListId =
                                        listMap[selectedListName];
                                    SmartListSheet().showEditBottomSheet(
                                      context,
                                      true,
                                      false,
                                      listId: selectedListId,
                                      items: item,
                                      isFromKitchen: true,
                                      isFromInsideItem: isFromParentSheet,
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
        );
      },
    );
  }
}
