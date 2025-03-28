import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/modules/home/home.dart';
import 'package:saver_bbk_main/modules/login/login.dart';
import 'package:saver_bbk_main/services/app_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? uid;
  bool? isGuest = false;
  @override
  void initState() {
    _initializeFCM();
    Future.delayed(
      Duration(milliseconds: 500),
    ).then((value) => _checkUserStatus());
    super.initState();
  }

  Future<void> _initializeFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await Services.updateFCMToken(token);
      }
    } else {
      if (kDebugMode) {
        print('❌ User declined or has not accepted permission');
      }
    }
  }

  Future<void> _checkUserStatus() async {
    uid = HiveHelper.getUID();
    isGuest = HiveHelper.getIsGuest();
    if (isGuest ?? false) {
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoModalPopupRoute(
          builder: (context) => MainScreen(currentIndex: 0),
        ),
        (route) => false,
      );
    } else if (uid != null) {
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoModalPopupRoute(
          builder: (context) => MainScreen(currentIndex: 0),
        ),
        (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoModalPopupRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    }
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
