import 'package:flutter/material.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class SaverTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final Color borderColor;
  final double borderRadius;

  const SaverTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.borderColor = AppColor.lightGrey,
    this.borderRadius = 7.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColor.lightGrey200),
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: borderColor) : null,
        suffixIcon:
            suffixIcon != null
                ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(suffixIcon, color: borderColor),
                )
                : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 12.0,
        ),
      ),
    );
  }
}
