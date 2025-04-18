import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class SaverTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final Color borderColor;
  final Color prefixIconColor;
  final Color suffixIconColor;
  final double borderRadius;
  final FocusNode? focus;
  final int minLines;
  bool isDark;
  final int maxlines;
  final VoidCallback? onEditingComplete;
  final String? Function(String?)? validator;
  void Function(String)? onChanged;

  SaverTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.inputFormatters = const [],
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      this.prefixIcon,
      this.isDark = false,
      this.focus,
      this.maxlines = 1,
      this.onEditingComplete,
      this.prefixIconColor = AppColor.lightGrey,
      this.suffixIcon,
      this.suffixIconColor = AppColor.lightGrey,
      this.validator,
      this.minLines = 1,
      this.onSuffixTap,
      this.borderColor = AppColor.lightGrey,
      this.borderRadius = 7.0,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxlines,
      focusNode: focus,
      onEditingComplete: onEditingComplete,
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: AppColor.red),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
            color: isDark ? Colors.grey.shade800 : AppColor.lightGrey200),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: prefixIconColor)
            : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: suffixIconColor),
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
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: AppColor.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 12.0,
        ),
      ),
    );
  }
}
