import 'package:flutter/material.dart';

import 'package:saver_bbk_main/profile/profile_page.dart';
import 'package:saver_bbk_main/styles/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saver App',
      theme: ThemeData(scaffoldBackgroundColor: AppColor.white),
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}
