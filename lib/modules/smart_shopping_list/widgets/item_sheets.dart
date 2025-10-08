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
import 'package:saver_bbk_main/l10n/app_localizations.dart';

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
        bool isListNameEmpty = false;
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
                  message: AppLocalizations.of(context)!.itemAddedSuccessfully,
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
                  message:
                      AppLocalizations.of(context)!.itemPurchasedSuccessfully,
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
                  message:
                      AppLocalizations.of(context)!.listNameChangedSuccessfully,
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
              if (state is RemoveItemFromSmartListSuccessState) {
                Navigator.pop(context);
              }
            },
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isItem
                                ? isView
                                    ? items?.name ?? "N/A"
                                    : AppLocalizations.of(context)!.addNewItem
                                : AppLocalizations.of(
                                    context,
                                  )!
                                    .editShoppingList,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Label(
                          text: isItem
                              ? AppLocalizations.of(context)!.itemName
                              : AppLocalizations.of(context)!.listName,
                        ),
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
                          hintText: isItem
                              ? AppLocalizations.of(context)!.enterItemName
                              : AppLocalizations.of(context)!.weeklyGrocery,
                          controller: itemNameController,
                        ),
                      ),
                    ),
                    if (isListNameEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          AppLocalizations.of(context)!.pleaseEnterAListName,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    if (isItem) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          AppLocalizations.of(context)!.quantity,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            IntrinsicWidth(
                              child: SaverDropdown(
                                items: units,
                                selectedItem: selectedUnit,
                                hint: AppLocalizations.of(context)!.choose,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => selectedUnit = value);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 12),
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
                                onUpdate: (newValue) => setState(() {
                                  quantity = newValue;
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (isView)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!
                              .noteWhenanItemIsPurchased,
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: AppColor.primaryColor),
                        ),
                      ),
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
                                            text: AppLocalizations.of(
                                              context,
                                            )!
                                                .purchased,
                                            isLoading: state
                                                is PurchasedItemLoadingState,
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AddItem(
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
                                            text: AppLocalizations.of(
                                              context,
                                            )!
                                                .removeFromList,
                                            isLoading: state
                                                is RemoveItemFromSmartListLoadingState,
                                            onPressed: () => context
                                                .read<SmartShoppingBloc>()
                                                .add(
                                                  RemoveItemSmartShoppingEvent(
                                                    listId: listId ?? "",
                                                    itemId: items?.id ?? "",
                                                  ),
                                                ),
                                            color: AppColor.red,
                                          ),
                                        ),
                                      ],
                                    )
                                  : SaverButton(
                                      text: (isFromKitchen ?? false)
                                          ? AppLocalizations.of(
                                              context,
                                            )!
                                              .moveToShopping
                                          : AppLocalizations.of(
                                              context,
                                            )!
                                              .addItem,
                                      isLoading: state
                                              is NewItemAddedToListLoadingState ||
                                          state is MovingItemLoadingState,
                                      onPressed: () {
                                        if (isFromKitchen ?? false) {
                                          context.read<SmartShoppingBloc>().add(
                                                MoveFromKitchenToSmartListEvent(
                                                  listId: listId ?? "",
                                                  item: Items(
                                                    id: items?.id ?? "",
                                                    name: items?.name ?? "",
                                                    quantity: quantity,
                                                    unit: selectedUnit,
                                                  ),
                                                  isFromParentSide:
                                                      isFromInsideItem ?? false,
                                                ),
                                              );
                                        } else {
                                          final name =
                                              itemNameController.text.trim();
                                          if (name.isEmpty) {
                                            setState(
                                              () => isListNameEmpty = true,
                                            );
                                            return;
                                          }
                                          setState(
                                              () => isListNameEmpty = false);
                                          context.read<SmartShoppingBloc>().add(
                                                AddNewItemSmartShoppingEvent(
                                                  listId: listId ?? "",
                                                  itemName: name,
                                                  itemQuantity: quantity,
                                                  itemUnit: selectedUnit,
                                                ),
                                              );
                                        }
                                      },
                                    )
                              : SaverButton(
                                  text:
                                      AppLocalizations.of(context)!.saveChanges,
                                  isLoading:
                                      state is ListNameChangedLoadingState,
                                  onPressed: () {
                                    final name = itemNameController.text.trim();
                                    if (name.isEmpty) {
                                      setState(() => isListNameEmpty = true);
                                      return;
                                    }
                                    setState(() => isListNameEmpty = false);
                                    context.read<SmartShoppingBloc>().add(
                                          UpdateSmartShopingListNameEvent(
                                            newName:
                                                itemNameController.text.trim(),
                                            listId: listId ?? "",
                                          ),
                                        );
                                  },
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
    bool showAlert = false;
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: StreamBuilder<List<Map<String, String>>>(
                stream: Services.getUserSmartList(),
                builder: (context, snapshot) {
                  List<String> listNames = snapshot.data
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
                    builder: (context, insidesetState) => Column(
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
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.selectAList,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 10),
                              SaverDropdown(
                                items: listNames,
                                selectedItem: selectedListName ?? "",
                                isLoading: snapshot.connectionState ==
                                    ConnectionState.waiting,
                                onChanged: (value) {
                                  insidesetState(() {
                                    selectedListName = value!;
                                  });
                                },
                              ),
                              if (showAlert)
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!
                                      .pleaseSelectAList,
                                  style: TextStyle(color: Colors.red),
                                ),
                              SizedBox(height: 15),
                              SaverButton(
                                text: AppLocalizations.of(context)!.addToList,
                                onPressed: () {
                                  if ((selectedListName?.isEmpty ?? false) ||
                                      (selectedListName == "") ||
                                      selectedListName == null) {
                                    setState(() => showAlert = true);
                                  } else {
                                    if (selectedListName != null) {
                                      String? selectedListId =
                                          listMap[selectedListName];
                                      setState(() => showAlert = false);
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
      },
    );
  }
}
