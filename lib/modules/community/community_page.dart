import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar("Community", context, isneedtopop: false),
    );
  }
}
