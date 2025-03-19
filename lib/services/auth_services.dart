import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/modules/home/home.dart';
import 'package:saver_bbk_main/modules/login/login.dart';
import 'package:saver_bbk_main/modules/login/otp/verify_otp.dart';

class AuthServices {
  static String verId = "";
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static void verifyPhoneNumber(BuildContext context, String number) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+91 $number',
      verificationCompleted: (PhoneAuthCredential credential) {
        signInWithPhoneNumber(
          context,
          credential.verificationId!,
          credential.smsCode!,
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return OtpVerificationScreen(phoneNumber: number);
            },
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static void logoutApp(BuildContext context) async {
    await _firebaseAuth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => LoginPage()));
  }

  static void submitOtp(BuildContext context, String otp) {
    signInWithPhoneNumber(context, verId, otp);
  }

  static Future<void> signInWithPhoneNumber(
    BuildContext context,
    String verificationId,
    String smsCode,
  ) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      await HiveHelper.putUID(userCredential.user!.uid);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const MainScreen();
          },
        ),
      );
      SaverSnackBar.show(
        context: context,
        message: "Login Success",
        isTrue: true,
      );
    } catch (e) {
      SaverSnackBar.show(
        context: context,
        message: "Login Failed",
        isTrue: false,
      );
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }
}
