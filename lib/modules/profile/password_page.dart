import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar("Password", context,isneedtopop: true),
      body: Column(
        children: [
          
        
      ]),
    );
  }
}