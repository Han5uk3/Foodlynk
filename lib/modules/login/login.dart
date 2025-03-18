import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safePadding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF2E2),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight - safePadding.top - safePadding.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.13,
                  horizontal: screenWidth * 0.1,
                ),
                child: Image.asset(
                  'assets/images/login.png',
                  fit: BoxFit.contain,
                ),
              ),
              _loginForm(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Widget _loginForm(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.07,
        vertical: 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Login Using Mobile Number',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Enter 10 digit mobile number',
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

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Expanded(
                child: Wrap(
                  children: [
                    const Text(
                      'I agree with the ',
                      style: TextStyle(color: AppColor.black),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Terms & Conditions',
                        style: TextStyle(color: AppColor.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: SaverOutlineButton(
                  onPressed: () {},
                  text: "Login with Password",
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColor.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: SaverButton(onPressed: () {}, text: "OTP")),
            ],
          ),

          const SizedBox(height: 25),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('OR', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Center(
            child: GestureDetector(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Continue as Guest',
                  style: TextStyle(color: AppColor.primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
