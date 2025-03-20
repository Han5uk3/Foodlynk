import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/services/auth_services.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  bool hasError = false;
  int resendSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendSeconds > 0) {
        setState(() {
          resendSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void resendOTP() {
    // Implement your OTP resend logic here
    setState(() {
      resendSeconds = 30;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: saverAppBar("Verify Phone Number", context, isneedtopop: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'OTP has been sent to ',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: ' ✓',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Form(
                child: PinCodeTextField(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: Color(0xFFD9D9D9),
                    inactiveColor: Color(0xFFD9D9D9),
                    selectedColor: Color(0xFF383838),
                  ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) {
                    AuthServices.submitOtp(context, otpController.text);
                  },
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    // Return true if you want to allow pasting
                    return true;
                  },
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: resendSeconds > 0 ? null : resendOTP,
                child: Text(
                  resendSeconds > 0
                      ? "Resend OTP in 00:${resendSeconds.toString().padLeft(2, '0')} s"
                      : "Resend OTP",
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: SaverButton(
                  text: "Verify",
                  onPressed: () {
                    if (otpController.text.length != 6) {
                      SaverSnackBar.show(
                        context: context,
                        message: "Please enter valid OTP",
                        isTrue: false,
                      );
                    } else {
                      AuthServices.submitOtp(context, otpController.text);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
