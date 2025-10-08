import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/services/auth_services.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

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
  bool isVerifying = false;

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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    setState(() {
      isVerifying = true;
    });

    AuthServices.verifyPhoneNumber(context, widget.phoneNumber);

    setState(() {
      resendSeconds = 30;
      isVerifying = false;
    });
    startTimer();
  }

  void verifyOTP() {
    if (otpController.text.length != 6) {
      errorController?.add(ErrorAnimationType.shake);
      SaverSnackBar.show(
        context: context,
        message: "Please enter valid 6-digit OTP",
        isTrue: false,
      );
    } else {
      AuthServices.submitOtp(context, otpController.text, widget.phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: saverAppBar(
          AppLocalizations.of(context)!.verifyPhoneNumber, context,
          isneedtopop: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: AppLocalizations.of(context)!.otpHasBeenSentTo,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const TextSpan(
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
              const SizedBox(height: 30),
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
                    activeColor: const Color(0xFFD9D9D9),
                    inactiveColor: const Color(0xFFD9D9D9),
                    selectedColor: const Color(0xFF383838),
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) {
                    verifyOTP();
                  },
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: resendSeconds > 0 ? null : resendOTP,
                child: Text(
                  resendSeconds > 0
                      ? "${AppLocalizations.of(context)!.resendOtpInS}00:${resendSeconds.toString().padLeft(2, '0')} s"
                      : "Resend OTP",
                  style: TextStyle(
                    color: resendSeconds > 0 ? Colors.grey : Colors.lightGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: SaverButton(
                    text: AppLocalizations.of(context)!.verify,
                    onPressed: verifyOTP),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
