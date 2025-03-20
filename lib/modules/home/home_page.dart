import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/modules/home/widgets/coins.dart';
import 'package:saver_bbk_main/modules/home/widgets/home_banner.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class HomePage extends StatefulWidget {
  final Function(int) onGridTap;
  const HomePage({super.key, required this.onGridTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> categories = [
    {
      "id": 1,
      "name": "Zero Waste Challenges",
      "image": "zero waste.svg",
      "color": 0xFFF8FFE1,
    },
    {
      "id": 2,
      "name": "Kitchen Manager",
      "image": "kichten manager.svg",
      "color": 0xFFFFFBEE,
    },
    {
      "id": 3,
      "name": "Smart Shopping List",
      "image": "list.svg",
      "color": 0xFFFFEEEF,
    },
    {
      "id": 4,
      "name": "Food Share",
      "image": "food share.svg",
      "color": 0xFFE9FBFF,
    },
    {
      "id": 5,
      "name": "Food Swap",
      "image": "food swap.svg",
      "color": 0xFFDFFFF3,
    },
    {
      "id": 6,
      "name": "Smart Recipes",
      "image": "smart recepies.svg",
      "color": 0xFFFFF7F6,
    },
    {
      "id": 7,
      "name": "Waste-Free Cooking",
      "image": "waste free cooking.svg",
      "color": 0xFFFAF0FA,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _homeBar(),
          Positioned(top: 140, left: 0, right: 0, child: HomeBanner()),
          Positioned(
            top: 280,
            left: 20,
            child: Label(
              text: "Quick Actions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 320),
            child: mainHomeGrid(),
          ),
        ],
      ),
    );
  }

  Widget gridItem(int index) {
    return GestureDetector(
      // FIXED: Wrap the callback in a function instead of calling it directly
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
                onPressed: () {},
                icon: Icon(Icons.language, color: AppColor.white),
              ),
              Coins(coins: 5),
            ],
          ),
        ],
      ),
    );
  }

  Widget mainHomeGrid() {
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
        return gridItem(index);
      },
    );
  }
}
