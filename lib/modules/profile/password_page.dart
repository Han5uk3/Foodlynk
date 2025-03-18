import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key, required this.isEdit});
  final bool isEdit;
  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool active = true;

  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController newpasswordcontroller = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmpasswordFocusNode = FocusNode();
  final GlobalKey<FormState> _formkey = GlobalKey();

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirm password cannot be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    if (value != passwordcontroller.text) {
      return "Passwords do not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          widget.isEdit
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(color: Colors.grey.shade200, thickness: 2),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 14,
                      right: 14,
                      bottom: 30,
                    ),
                    child: SaverButton(
                      text: "Save Password",
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              )
              : null,
      appBar: saverAppBar("Password", context, isneedtopop: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Label(
                text: "Create New Password",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 7),
              SaverTextField(
                suffixIconColor: AppColor.black,
                suffixIcon:
                    active
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                onSuffixTap: () {
                  setState(() {
                    active = !active;
                  });
                },
                validator: (p0) => validatePassword(p0),
                focus: _passwordFocusNode,
                onEditingComplete:
                    () => FocusScope.of(
                      context,
                    ).requestFocus(_confirmpasswordFocusNode),
                hintText: "Enter Password",
                controller: passwordcontroller,
                keyboardType: TextInputType.visiblePassword,
                isPassword: active,
              ),
              SizedBox(height: 20),
              Label(
                text: "Confirm Password",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 7),
              SaverTextField(
                validator: (p0) => validateConfirmPassword(p0),
                focus: _confirmpasswordFocusNode,
                keyboardType: TextInputType.visiblePassword,
                isPassword: false,
                hintText: "Confirm Password",
                controller: newpasswordcontroller,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
              SizedBox(height: 20),
              widget.isEdit
                  ? SizedBox.shrink()
                  : SaverButton(
                    text: "Save Password",
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        Navigator.pop(context);
                      }
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
