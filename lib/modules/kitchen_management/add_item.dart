import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_selector/number_selector.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/calender.dart';
import 'package:saver_bbk_main/common_widget/date_compare.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/image_picker.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/kitchen_management/bloc/kitchen_manager_bloc.dart';
import 'package:saver_bbk_main/modules/kitchen_management/kitchen_manager.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/bloc/smart_shopping_bloc.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/widgets/item_sheets.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddItem extends StatefulWidget {
  final String? dateString;
  final bool isEdit;
  final Items? item;
  final String? listId;
  final bool? isFromSmartList;
  const AddItem({
    super.key,
    required this.isEdit,
    this.dateString,
    this.item,
    this.isFromSmartList,
    this.listId,
  });

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController itemNameController = TextEditingController();
  String? selectedUnit;
  int numberOfQuantity = 0;
  String selectedCategory = "";
  DateTime selectedExpiryDate = DateTime.now();
  bool _isLoading = false;

  void _onDatePicked(DateTime date) {
    setState(() {
      selectedExpiryDate = date;
    });
  }

  List<String> unit = ["Kg", "Pcs", "ml", "Ltr", "gm", "Nos"];
  List<String> category = [
    "Dairy",
    "Meat",
    "Oils",
    "Poultry",
    "Fruits",
    "Vegetables",
    "Seafood",
  ];
  File? _imageFile;

  void _setImage(File image) {
    setState(() {
      _imageFile = image;
    });
  }

  @override
  void initState() {
    if (widget.isEdit) {
      itemNameController.text = widget.item!.name ?? "";
      selectedUnit = widget.item!.unit ?? "";
      numberOfQuantity = widget.item!.quantity ?? 0;
      selectedCategory = widget.item!.category ?? "";
      if (widget.item!.expiredDate != null) {
        if (widget.item!.expiredDate is Timestamp) {
          selectedExpiryDate = (widget.item!.expiredDate as Timestamp).toDate();
        } else if (widget.item!.expiredDate is DateTime) {
          selectedExpiryDate = widget.item!.expiredDate;
        } else if (widget.item!.expiredDate is String) {
          try {
            selectedExpiryDate = DateTime.parse(widget.item!.expiredDate);
          } catch (e) {
            selectedExpiryDate = DateTime.now();
          }
        }
      }
    } else if (widget.isFromSmartList ?? false) {
      itemNameController.text = widget.item!.name ?? "";
      selectedUnit = widget.item!.unit;
      numberOfQuantity = widget.item!.quantity ?? 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int days = 0;
    widget.isEdit
        ? days = getDateDifferenceNumber(widget.dateString!)
        : days = 0;

    return Scaffold(
      appBar: saverAppBar(
        widget.isEdit ? "Edit Item" : AppLocalizations.of(context)!.addItem,
        context,
        isneedtopop: true,
        iswhite: true,
      ),
      body: BlocListener<KitchenManagerBloc, KitchenManagerState>(
        listener: (context, state) {
          if (state is AddNewStateLoading) {
            setState(() {
              _isLoading = state.isLoading;
            });
          }

          if (state is AddNewStateSuccess) {
            Navigator.pop(context);
            SaverSnackBar.shower(
              context: context,
              message: AppLocalizations.of(context)!.newItemAddedToKitchen,
              isTrue: true,
            );
          }

          if (state is AddNewStateError) {
            Navigator.pop(context);
            SaverSnackBar.shower(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          }
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.isEdit
                            ? Column(
                              children: [
                                Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          days <= 0
                                              ? AppColor.red
                                              : days >= 0 && days < 3
                                              ? AppColor.yellow
                                              : AppColor.green,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      spacing: 2,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          days <= 0
                                              ? Icons.sentiment_neutral_outlined
                                              : days >= 0 && days < 3
                                              ? Icons
                                                  .sentiment_satisfied_alt_outlined
                                              : Icons
                                                  .sentiment_very_satisfied_outlined,
                                          size: 18,
                                          color:
                                              days <= 0
                                                  ? AppColor.red
                                                  : days >= 0 && days < 3
                                                  ? AppColor.yellow
                                                  : AppColor.green,
                                        ),
                                        Text(
                                          getDateDifferenceMessage(
                                            widget.dateString!,
                                          ),
                                          style: TextStyle(
                                            color:
                                                days <= 0
                                                    ? AppColor.red
                                                    : days >= 0 && days < 3
                                                    ? AppColor.yellow
                                                    : AppColor.green,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                            : SizedBox.shrink(),

                        Label(
                          text: AppLocalizations.of(context)!.itemName,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        IgnorePointer(
                          ignoring: widget.isEdit,
                          child: SaverTextField(
                            hintText:
                                AppLocalizations.of(context)!.enterItemName,
                            controller: itemNameController,
                            validator: _validateItemName,
                          ),
                        ),
                        SizedBox(height: 20),
                        Label(
                          text: AppLocalizations.of(context)!.quantity,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 30,
                          children: [
                            IntrinsicWidth(
                              child: SaverDropdown(
                                items: unit,
                                selectedItem: selectedUnit ?? "",
                                isView: widget.isEdit,
                                hint: AppLocalizations.of(context)!.choose,
                                onChanged:
                                    widget.isEdit
                                        ? (value) {
                                          null;
                                        }
                                        : (value) {
                                          setState(() {
                                            selectedUnit = value!;
                                          });
                                        },
                              ),
                            ),
                            Expanded(
                              child: IgnorePointer(
                                ignoring: widget.isEdit,
                                child: NumberSelector.plain(
                                  hasBorder: true,
                                  showMinMax: false,
                                  min: 1,
                                  iconColor: Colors.grey.shade500,
                                  borderRadius: 6,
                                  borderColor: Colors.grey.shade300,
                                  backgroundColor: AppColor.white,
                                  current: numberOfQuantity,
                                  onUpdate: (newValue) {
                                    setState(() {
                                      numberOfQuantity = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Label(
                          text: AppLocalizations.of(context)!.category,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        SaverDropdown(
                          items: category,
                          selectedItem: selectedCategory,
                          isView: widget.isEdit,
                          hint: AppLocalizations.of(context)!.choose,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Label(
                          text: AppLocalizations.of(context)!.expiryDate,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        ShowCalendar(
                          isEdit: widget.isEdit,
                          restrictBackDates: true,
                          initialDate: selectedExpiryDate,
                          onDatePicked: _onDatePicked,
                        ),
                        SizedBox(height: 20),
                        Label(
                          text: AppLocalizations.of(context)!.uploadImage,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child:
                              widget.isEdit
                                  ? DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(12),
                                    dashPattern: [6, 3],
                                    strokeWidth: 2,
                                    color: Colors.grey.shade400,
                                    child: SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Center(
                                        child: Icon(
                                          size: 40,
                                          Icons.add_photo_alternate_outlined,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  )
                                  : Row(
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                        _imageFile!,
                                                      ),
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
                                                    onTap:
                                                        widget.isEdit
                                                            ? null
                                                            : () {
                                                              setState(() {
                                                                _imageFile =
                                                                    null;
                                                              });
                                                            },
                                                    child: CircleAvatar(
                                                      radius: 10,
                                                      backgroundColor:
                                                          Colors.white70,
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
                                      _imageFile == null
                                          ? widget.isEdit
                                              ? SizedBox()
                                              : ImagePickerButton(
                                                isFood: false,
                                                onImageSelected: _setImage,
                                              )
                                          : SizedBox(),
                                    ],
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          widget.isEdit
              ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 20,
                ),
                child: _editItemButton(widget.item!),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 20,
                ),
                child: SizedBox(
                  height: 40,
                  child: SaverButton(
                    isLoading: _isLoading,
                    text: AppLocalizations.of(context)!.addItem,
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      if (itemNameController.text.isEmpty) {
                        SaverSnackBar.show(
                          context: context,
                          message:
                              AppLocalizations.of(context)!.plaeseenterItemName,
                          isTrue: false,
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      } else if (selectedUnit == null) {
                        SaverSnackBar.show(
                          context: context,
                          message:
                              AppLocalizations.of(
                                context,
                              )!.pleaseSelectAUnitType,
                          isTrue: false,
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      } else if (numberOfQuantity == 0) {
                        SaverSnackBar.show(
                          context: context,
                          message:
                              AppLocalizations.of(context)!.pleaseEnterQuantity,
                          isTrue: false,
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      } else if (selectedCategory == "") {
                        SaverSnackBar.show(
                          context: context,
                          message:
                              AppLocalizations.of(
                                context,
                              )!.pleaseSelectACategory,
                          isTrue: false,
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      }

                      (widget.isFromSmartList ?? false)
                          ? context.read<SmartShoppingBloc>().add(
                            MarkAsPurchasedSmartShoppingEvent(
                              item: Items(
                                id: widget.item?.id,
                                name: itemNameController.text,
                                quantity: numberOfQuantity,
                                unit: selectedUnit ?? "",
                                category: selectedCategory,
                                expiredDate: selectedExpiryDate,
                              ),
                              listId: widget.listId ?? "",
                            ),
                          )
                          : context.read<KitchenManagerBloc>().add(
                            AddNewItemEvent(
                              item: Items(
                                name: itemNameController.text,
                                quantity: numberOfQuantity,
                                unit: selectedUnit ?? "",
                                category: selectedCategory,
                                expiredDate: selectedExpiryDate,
                              ),
                              imageFile: _imageFile,
                            ),
                          );
                    },
                  ),
                ),
              ),
    );
  }

  Widget _editItemButton(Items item) {
    return Row(
      spacing: 20,
      children: [
        Expanded(
          child: SaverButton(
            text: AppLocalizations.of(context)!.moveToShopping,
            onPressed:
                () => SmartListSheet().showListSelector(
                  context,
                  item,
                  isFromParentSheet: true,
                ),
          ),
        ),
        Expanded(
          child: SaverButton(
            text: AppLocalizations.of(context)!.removeFromList,
            onPressed:
                () => context.read<KitchenManagerBloc>().add(
                  RemoveItemEvent(
                    itemId: widget.item?.id ?? "",
                    beforeExpiry: !itemRemovedBeforeExpiry(widget.item!),
                    itemCount: widget.item?.quantity ?? 0,
                    inSideParentPage: true,
                  ),
                ),
            color: AppColor.red,
          ),
        ),
      ],
    );
  }

  String? _validateItemName(String? value) {
    if (value == null || value.isEmpty) {
      return "Item name can't be empty";
    }

    final RegExp itemRegExp = RegExp(r'^[a-zA-Z]+$');
    if (!itemRegExp.hasMatch(value)) {
      return "Item name must start with a letter";
    }
    return null;
  }
}
