import 'package:flutter/material.dart';
import 'package:saver_bbk_main/modules/community/community_page.dart';
import 'package:saver_bbk_main/modules/food_share/food_share_home_page.dart';
import 'package:saver_bbk_main/modules/food_swap/food_swap_page.dart';
import 'package:saver_bbk_main/modules/home/home_page.dart';
import 'package:saver_bbk_main/modules/kitchen_management/kitchen_manager.dart';
import 'package:saver_bbk_main/modules/notifications/notifications_page.dart';
import 'package:saver_bbk_main/modules/profile/profile_page.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/smart_shopping_list_home.dart';
import 'package:saver_bbk_main/modules/zero_waste_challenges/zero_waste_challenges.dart';
import 'package:saver_bbk_main/modules/zero_waste_cooking/zero_waste_cooking_page.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class MainScreen extends StatefulWidget {
  final int currentIndex;

  const MainScreen({super.key, required this.currentIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int? _activeGridPage;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _activeGridPage = null;
  }

  void onGridTap(int index) {
    setState(() {
      _activeGridPage = index;
    });
  }

  void goBack() {
    setState(() {
      _activeGridPage = null;

      _currentIndex = 0;
    });
  }

  Widget _getCurrentPage() {
    if (_activeGridPage != null) {
      switch (_activeGridPage) {
        case 0:
          return ZeroWasteChallenges(onBack: goBack);
        case 1:
          return KitchenManager(onBack: goBack);
        case 2:
          return SmartShoppingHome(onBack: goBack);
        case 3:
          return FoodShareHomePage(onBack: goBack);
        case 4:
          return FoodSwapPage(onBack: goBack);
        case 5:
          return Page6(onBack: goBack);
        case 6:
          return ZeroWasteCookingPage(onBack: goBack);
        default:
          return HomePage(onGridTap: onGridTap);
      }
    }

    switch (_currentIndex) {
      case 0:
        return HomePage(onGridTap: onGridTap);
      case 1:
        return CommunityPage();
      case 2:
        return NotificationsPage();
      case 3:
        return const ProfilePage();
      default:
        return HomePage(onGridTap: onGridTap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_activeGridPage != null) {
          goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _getCurrentPage(),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColor.white,
            elevation: 0,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _activeGridPage = null;
                _currentIndex = index;
              });
            },
            selectedItemColor: AppColor.appbarColor,
            unselectedItemColor: Colors.grey,
            iconSize: 28,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: [
              _bottomNavBarItem(0, Icons.home, Icons.home_outlined, 'Home'),
              _bottomNavBarItem(
                1,
                Icons.forum,
                Icons.forum_outlined,
                'Community',
              ),
              _bottomNavBarItem(
                2,
                Icons.notifications,
                Icons.notifications_none,
                'Notification',
              ),
              _bottomNavBarItem(
                3,
                Icons.account_circle,
                Icons.account_circle_outlined,
                'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(
    int index,
    IconData selectedIcon,
    IconData unselectedIcon,
    String title,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(_currentIndex == index ? selectedIcon : unselectedIcon),
      label: title,
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Welcome to Notification'));
  }
}

class Page1 extends StatelessWidget {
  final VoidCallback onBack;
  const Page1({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, 'Page 1', onBack);
  }
}

class Page2 extends StatelessWidget {
  final VoidCallback onBack;
  const Page2({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, 'Page 2', onBack);
  }
}

class Page3 extends StatelessWidget {
  final VoidCallback onBack;
  const Page3({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, 'Page 3', onBack);
  }
}

class Page4 extends StatelessWidget {
  final VoidCallback onBack;
  const Page4({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, 'Page 4', onBack);
  }
}

class Page5 extends StatelessWidget {
  final VoidCallback onBack;
  const Page5({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, 'Page 5', onBack);
  }
}

class Page6 extends StatelessWidget {
  final VoidCallback onBack;
  const Page6({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, 'Page 6', onBack);
  }
}

class Page7 extends StatelessWidget {
  final VoidCallback onBack;
  const Page7({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, 'Page 7', onBack);
  }
}

Widget _buildPage(BuildContext context, String title, VoidCallback onBack) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
    ),
    body: Center(child: Text(title, style: TextStyle(fontSize: 24))),
  );
}
