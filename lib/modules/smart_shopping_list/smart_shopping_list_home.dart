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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        "Smart Shopping List",
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
          });
          Navigator.pop(context);
          SaverSnackBar.show(
            context: context,
            message: "Your new list has been created",
            isTrue: true,
          );
        }
        if (state is CreateNewSmartShoppingListFailureState) {
          _isLoading = false;
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
            _buildListCard(),
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
              hintText: "search list",
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      "Shopping Lists",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildListCard() {
    return StreamBuilder<List<SmartShoppingModel>>(
      stream: Services.getSmartList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SaverLoader();
        }
        if (snapshot.data?.isEmpty ?? false) {
          return Center(child: Text("No shopping lists found"));
        }
        final data = snapshot.data ?? [];
        List allItems =
            data
                .map((i) => i.items?.where((item) => item.status == "AL") ?? [])
                .expand((i) => i)
                .toList();
        List purchasedList =
            data
                .map((i) => i.items?.where((item) => item.status == "PR") ?? [])
                .expand((i) => i)
                .toList();
        return ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            SmartShoppingModel item = data[index];
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
                  );
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
                          value: (allItems.length / purchasedList.length) * 100,
                          color: Colors.orange,
                          backgroundColor: AppColor.lightGrey,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "${allItems.length} of ${purchasedList.length} items purchased",
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
      },
    );
  }

  _showAddBottomSheet() {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return Column(
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
                    "Add Shopping List",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
            Divider(color: AppColor.lightGrey, thickness: 1.5, height: 1.5),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
              child: Text("List Name", style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 8),
              child: SaverTextField(
                hintText: "Enter list name",
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
                text: "Save Changes",
                isLoading: _isLoading,
                onPressed:
                    () => context.read<SmartShoppingBloc>().add(
                      CreateNewSmartShoppingEvent(
                        listName: listNameController.text.trim(),
                      ),
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
