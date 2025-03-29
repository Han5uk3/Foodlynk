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
import 'package:saver_bbk_main/styles/colors.dart';

class SmartListSheet {
  void showEditBottomSheet(
    BuildContext context,
    bool isItem,
    bool isView, {
    Items? items,
    String? listId,
  }) {
    final TextEditingController itemNameController = TextEditingController(
      text: items?.name ?? '',
    );
    int quantity = items?.quantity ?? 1;

    List<String> units = ["Kg", "Pcs", "ml", "Ltr", "gm", "Nos"];
    String selectedUnit = items?.unit ?? "Pcs";

    showModalBottomSheet(
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
        return BlocListener<SmartShoppingBloc, SmartShoppingState>(
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
                    child: Label(text: isItem ? "Item Name" : "List Name"),
                  ),
                  IgnorePointer(
                    ignoring: isView,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      child: SaverTextField(
                        hintText: isItem ? "Enter Item Name" : "Weekly Grocery",
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
                                            state is PurchasedItemLoadingState,
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
                                  text: "Add Item",
                                  isLoading:
                                      state is NewItemAddedToListLoadingState,
                                  onPressed:
                                      () =>
                                          context.read<SmartShoppingBloc>().add(
                                            AddNewItemSmartShoppingEvent(
                                              listId: listId ?? "",
                                              itemName:
                                                  itemNameController.text
                                                      .trim(),
                                              itemQuantity: quantity,
                                              itemUnit: selectedUnit,
                                            ),
                                          ),
                                )
                            : SaverButton(
                              text: "Save Changes",

                              onPressed: () => Navigator.pop(context),
                            );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
