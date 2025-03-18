import 'package:flutter/material.dart';
import 'package:saver_bbk_main/modules/login/login.dart';
import 'package:saver_bbk_main/modules/splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saver App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: LoginPage(),
    );
  }
}
