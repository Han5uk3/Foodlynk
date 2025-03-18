import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/modules/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoModalPopupRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    });
    super.initState();
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
