import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
// import 'package:saver_bbk_main/common_widget/localization.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/modules/home/home.dart';
import 'package:saver_bbk_main/modules/login/login_with_password.dart';
import 'package:saver_bbk_main/services/auth_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isChecked = false;
  bool isVerifying = false;

  void _continueAsGuest() {
    HiveHelper.putisGuest(true);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MainScreen(currentIndex: 0)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2E2),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_imageView(), _loginForm()],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Widget _imageView() {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 40),
      child: SizedBox(
        height: 370,
        width: double.infinity,
        child: Stack(
          children: [
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: IconButton(
            //     onPressed: () => Localization.showLanguageDialog(context),
            //     icon: Icon(Icons.language, color: Colors.black),
            //   ),
            // ),
            Center(
              child: Image.asset(
                'assets/images/login.png',
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.loginUsingMobileNumber,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: _phoneController,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                counterText: "",
                hintText:
                    AppLocalizations.of(context)!.enterTenDigitMobileNumber,
                prefixText: '+91 - ',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                  activeColor: AppColor.black,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.iAgreeWithThe,
                style: TextStyle(color: AppColor.black),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  AppLocalizations.of(context)!.termsAndConditions,
                  style: TextStyle(color: AppColor.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: SaverOutlineButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginWithPassword(),
                    ),
                  ),
                  text: AppLocalizations.of(context)!.loginWithPassword,
                  style: TextStyle(fontSize: 13, color: AppColor.primaryColor),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SaverButton(
                  onPressed: () {
                    if (_phoneController.text.length == 10) {
                      _isChecked
                          ? AuthServices.verifyPhoneNumber(
                              context,
                              _phoneController.text,
                            )
                          : SaverSnackBar.show(
                              context: context,
                              message: AppLocalizations.of(
                                context,
                              )!
                                  .pleaseAcceptOurTermsAndConditions,
                              isTrue: false,
                            );
                    } else {
                      SaverSnackBar.show(
                        context: context,
                        message:
                            AppLocalizations.of(context)!.enterMobileNumber,
                        isTrue: false,
                      );
                    }
                  },
                  text: AppLocalizations.of(context)!.otp,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppLocalizations.of(context)!.or,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _continueAsGuest,
              child: Text(
                AppLocalizations.of(context)!.continueAsGuest,
                style: TextStyle(color: AppColor.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
