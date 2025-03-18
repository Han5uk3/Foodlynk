import 'package:flutter/material.dart';
import 'package:saver_bbk_main/profile/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saver App',
      theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      
      ),
      home: ProfilePage(),
    );
  }
}
