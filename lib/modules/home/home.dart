import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/guest_pop_up.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/modules/community/community_page.dart';
import 'package:saver_bbk_main/modules/food_share/food_share_all_page.dart';
import 'package:saver_bbk_main/modules/food_swap/food_swap_page.dart';
import 'package:saver_bbk_main/modules/home/home_page.dart';
import 'package:saver_bbk_main/modules/kitchen_management/kitchen_manager.dart';
import 'package:saver_bbk_main/modules/learn_save/learn_and_save.dart';
import 'package:saver_bbk_main/modules/notifications/notifications_page.dart';
import 'package:saver_bbk_main/modules/profile/profile_page.dart';
import 'package:saver_bbk_main/modules/smart_recipes/smart_recipe.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/smart_shopping_list_home.dart';
import 'package:saver_bbk_main/modules/zero_waste_challenges/zero_waste_challenges.dart';
import 'package:saver_bbk_main/modules/zero_waste_cooking/zero_waste_cooking_page.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/services/initilize_notification.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

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
    Services.isGuest = HiveHelper.getIsGuest();
    Services.uid = HiveHelper.getUID();
    if (Services.isGuest == true || Services.uid == null) {
      return;
    } else {
      InitilizeNotification.initializeFCM();
    }
    _currentIndex = widget.currentIndex;
    _activeGridPage = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityBloc>().add(LoadChatRoomsEvent());
    });
    super.initState();
  }

  void onGridTap(int index) {
    if (Services.isGuest ?? false) {
      GuestPopUp.showGuestFeaturePopup(context);
      return;
    }
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
          return FoodShareAllPage(onBack: goBack);
        case 4:
          return FoodSwapPage(onBack: goBack);
        case 5:
          return GenerateRecipePage(onBack: goBack);
        case 6:
          return ZeroWasteCookingPage(onBack: goBack);
        case 7:
          return PdfGridPage(onBack: goBack);
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
              if ((Services.isGuest ?? false) && (index == 1 || index == 2)) {
                GuestPopUp.showGuestFeaturePopup(context);
                return;
              }
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
              _bottomNavBarItem(
                0,
                Icons.home,
                Icons.home_outlined,
                AppLocalizations.of(context)!.home,
              ),
              _bottomNavBarItem(
                1,
                Icons.forum,
                Icons.forum_outlined,
                AppLocalizations.of(context)!.community,
              ),
              _bottomNavBarItem(
                2,
                Icons.notifications,
                Icons.notifications_none,
                AppLocalizations.of(context)!.notification,
              ),
              _bottomNavBarItem(
                3,
                Icons.account_circle,
                Icons.account_circle_outlined,
                AppLocalizations.of(context)!.profile,
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
