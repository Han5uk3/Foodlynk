import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110,
      margin: EdgeInsets.all(12),
      child: SvgPicture.asset("assets/brandlogo/demo.svg"),
    );
  }
}
