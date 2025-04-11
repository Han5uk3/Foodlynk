import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/modules/home/widgets/coins.dart';
import 'package:saver_bbk_main/modules/home/widgets/home_banner.dart';
import 'package:saver_bbk_main/modules/profile/bloc/profile_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  final Function(int) onGridTap;
  const HomePage({super.key, required this.onGridTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        "id": 1,
        "name": AppLocalizations.of(context)!.zeroWasteChallenges,
        "image": "zero waste.svg",
        "color": 0xFFF8FFE1,
      },
      {
        "id": 2,
        "name": AppLocalizations.of(context)!.kitchenManager,
        "image": "kichten manager.svg",
        "color": 0xFFFFFBEE,
      },
      {
        "id": 3,
        "name": AppLocalizations.of(context)!.smartShoppingList,
        "image": "list.svg",
        "color": 0xFFFFEEEF,
      },
      {
        "id": 4,
        "name": AppLocalizations.of(context)!.foodShare,
        "image": "food share.svg",
        "color": 0xFFE9FBFF,
      },
      {
        "id": 5,
        "name": AppLocalizations.of(context)!.foodSwap,
        "image": "food swap.svg",
        "color": 0xFFDFFFF3,
      },
      {
        "id": 6,
        "name": AppLocalizations.of(context)!.smartRecipes,
        "image": "smart recepies.svg",
        "color": 0xFFFFF7F6,
      },
      {
        "id": 7,
        "name": AppLocalizations.of(context)!.zeroWasteCooking,
        "image": "waste free cooking.svg",
        "color": 0xFFFAF0FA,
      },
      {
        "id": 8,
        "name": AppLocalizations.of(context)!.learnAndSave,
        "image": "Learn & Save.svg",
        "color": 0xFFfad7ee,
      },
    ];
    return Scaffold(
      body: Stack(
        children: [
          _homeBar(),
          Positioned(top: 140, left: 0, right: 0, child: HomeBanner()),
          Positioned(
            top: 280,
            left: 20,
            child: Label(
              text: AppLocalizations.of(context)!.quickActions,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 320),
            child: mainHomeGrid(categories),
          ),
        ],
      ),
    );
  }

  Widget gridItem(int index, List<Map<String, dynamic>> categories) {
    return GestureDetector(
      onTap: () {
        widget.onGridTap(index);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(categories[index]["color"]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadsvg("assets/icons/home_icons/${categories[index]["image"]}"),
            const SizedBox(height: 20),
            Text(
              categories[index]["name"],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeBar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.appbarColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      padding: const EdgeInsets.only(left: 25, right: 25, top: 50, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          loadsvg("assets/brandlogo/brand_white.svg"),
          Row(
            children: [
              IconButton(
                onPressed: () => _showLanguageDialog(context),
                icon: Icon(Icons.language, color: AppColor.white),
              ),
              StreamBuilder<int>(
                stream: Services.getUserPointsStream(),
                builder: (context, snapshot) {
                  return Coins(coins: snapshot.data ?? 0);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget mainHomeGrid(List<Map<String, dynamic>> categories) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 15,
        childAspectRatio: 3 / 2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return gridItem(index, categories);
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Choose Language",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildLanguageOption(
                      context,
                      "English",
                      "assets/icons/united-states.svg",
                      "en",
                    ),
                    SizedBox(height: 15),
                    Divider(height: 1),
                    SizedBox(height: 15),
                    _buildLanguageOption(
                      context,
                      "العربية",
                      "assets/icons/flag.svg",
                      "ar",
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppColor.appbarColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String language,
    String flagAsset,
    String langCode,
  ) {
    return InkWell(
      onTap: () {
        context.read<ProfileBloc>().add(ChangeLocale(languageCode: langCode));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Language changed to $language"),
            backgroundColor: AppColor.appbarColor,
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(height: 40, width: 40, child: loadsvg(flagAsset)),
            SizedBox(width: 15),
            Text(
              language,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
