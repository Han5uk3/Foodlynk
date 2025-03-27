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
  final int maxlines;
  final VoidCallback? onEditingComplete;
  final String? Function(String?)? validator;

  const SaverTextField({
    super.key,
    required this.hintText,

    required this.controller,
    this.inputFormatters = const [],
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
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
  });

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
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColor.lightGrey200),
        prefixIcon:
            prefixIcon != null
                ? Icon(prefixIcon, color: prefixIconColor)
                : null,
        suffixIcon:
            suffixIcon != null
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 12.0,
        ),
      ),
    );
  }
}
