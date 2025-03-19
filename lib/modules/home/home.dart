import 'package:flutter/material.dart';
import 'package:saver_bbk_main/modules/home/home_page.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const CommunityScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: SizedBox(
          height: 100,
          child: BottomNavigationBar(
            backgroundColor: AppColor.white,
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: AppColor.appbarColor,
            unselectedItemColor: Colors.grey,
            iconSize: 28,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: [
              _bottomNavBarItem(
                0,
                Icons.home_filled,
                Icons.home_outlined,
                'Home',
              ),
              _bottomNavBarItem(
                1,
                Icons.group,
                Icons.group_outlined,
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
                Icons.person,
                Icons.person_outline,
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
      icon: Column(
        children: [
          Icon(_selectedIndex == index ? selectedIcon : unselectedIcon),
          const SizedBox(height: 3),
        ],
      ),
      label: title,
    );
  }
}

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: const Center(child: Text('Welcome to Community')),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification')),
      body: const Center(child: Text('Welcome to Notifications')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Welcome to Profile')),
    );
  }
}
