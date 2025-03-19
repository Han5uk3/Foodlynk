import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/modules/home/home.dart';
import 'package:saver_bbk_main/modules/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? uid;
  @override
  void initState() {
    uid = HiveHelper.getUID();
    Future.delayed(const Duration(seconds: 3), () => _checkLogin());
    super.initState();
  }

  void _checkLogin() {
    if (uid != null) {
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoModalPopupRoute(builder: (context) => MainScreen()),
        (route) => false,
      );
    } else {
      _checkUser();
    }
  }

  void _checkUser() async {
    // final bool isUserExist = await HiveHelper.isUserExist();
    // if (isUserExist) {
    //   _checkLogin();
    // } else {
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoModalPopupRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 300),
          Image.asset('assets/brandlogo/Logo.png'),
          Image.asset('assets/images/splash_screen.png'),
        ],
      ),
    );
  }
}
