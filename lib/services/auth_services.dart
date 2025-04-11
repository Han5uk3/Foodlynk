import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/modules/home/home.dart';
import 'package:saver_bbk_main/modules/login/otp/verify_otp.dart';
import 'package:saver_bbk_main/modules/profile/edit_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthServices {
  static String verId = "";
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static void verifyPhoneNumber(BuildContext context, String number) async {
    showLoadingDialog(context, AppLocalizations.of(context)!.sendingOtp);
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+965 $number',
      verificationCompleted: (PhoneAuthCredential credential) {
        Navigator.pop(context);
        signInWithPhoneNumber(
          context,
          credential.verificationId!,
          credential.smsCode!,
          '+965 $number',
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        Navigator.pop(context);
        if (e.code == 'invalid-phone-number') {
          SaverSnackBar.show(
            context: context,
            message: "Invalid phone number format",
            isTrue: false,
          );
        } else {
          SaverSnackBar.show(
            context: context,
            message: "Verification failed: ${e.message}",
            isTrue: false,
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pop(context);
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
      codeAutoRetrievalTimeout: (String verificationId) {
        try {
          Navigator.pop(context);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      },
      timeout: const Duration(seconds: 30),
    );
  }

  static void submitOtp(BuildContext context, String otp, String phoneNumber) {
    showLoadingDialog(context, 'Verifying OTP...');
    signInWithPhoneNumber(context, verId, otp, phoneNumber);
  }

  static Future signInWithPhoneNumber(
    BuildContext context,
    String verificationId,
    String smsCode,
    String phoneNumber,
  ) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      await checkUser(userCredential.user!.uid, context, smsCode, phoneNumber);
    } catch (e) {
      try {
        Navigator.pop(context);
      } catch (dialogError) {
        if (kDebugMode) {
          print(dialogError);
        }
      }

      SaverSnackBar.show(
        context: context,
        message: AppLocalizations.of(context)!.otpVerificationFailed,
        isTrue: false,
      );

      if (kDebugMode) {
        print("Auth Error: $e");
      }
    }
  }

  static Future checkUser(
    String uid,
    BuildContext context,
    String otp,
    String phoneNumber,
  ) async {
    try {
      if (!isDialogShowing(context)) {
        showLoadingDialog(context, 'Checking account...');
      }

      final querySnapshot =
          await Collections.users.where('uid', isEqualTo: uid).get();
      try {
        Navigator.pop(context);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      if (querySnapshot.docs.isNotEmpty) {
        await HiveHelper.putUID(uid);
        await HiveHelper.putisGuest(false);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(currentIndex: 0),
          ),
          (route) => false,
        );

        SaverSnackBar.show(
          context: context,
          message: AppLocalizations.of(context)!.loginSuccess,
          isTrue: true,
        );
      } else {
        await HiveHelper.putisGuest(false);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                (context) => EditProfilePage(
                  isEdit: false,
                  phoneNumber: phoneNumber,
                  email: "",
                  isFromEmailLogin: false,
                ),
          ),
          (route) => false,
        );

        SaverSnackBar.show(
          context: context,
          message:
              AppLocalizations.of(context)!.welcomePleaseCompleteYourProfile,
          isTrue: true,
        );
      }
    } catch (e) {
      try {
        Navigator.pop(context);
      } catch (dialogError) {
        if (kDebugMode) {
          print(dialogError);
        }
      }

      SaverSnackBar.show(
        context: context,
        message: "Error checking user profile",
        isTrue: false,
      );

      if (kDebugMode) {
        print("Database Error: $e");
      }
    }
  }

  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                ),
                const SizedBox(height: 20),
                Text(message, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  static bool isDialogShowing(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent != true;
  }

  static Future<void> resetPasswordWithEmail(
    BuildContext context,
    String email,
  ) async {
    try {
      AuthServices.showLoadingDialog(
        context,
        AppLocalizations.of(context)!.sendingResetLink,
      );

      await _firebaseAuth.sendPasswordResetEmail(email: email);

      try {
        Navigator.pop(context);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      Navigator.of(context).pop();

      SaverSnackBar.show(
        context: context,
        message:
            AppLocalizations.of(context)!.passwordResetEmailSentSuccessfully,
        isTrue: true,
      );
    } on FirebaseAuthException catch (e) {
      try {
        Navigator.pop(context);
      } catch (dialogError) {
        if (kDebugMode) {
          print(dialogError);
        }
      }

      String errorMessage = "Failed to send reset email";

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email address.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }

      SaverSnackBar.show(
        context: context,
        message: errorMessage,
        isTrue: false,
      );

      if (kDebugMode) {
        print("Reset Password Error: ${e.code} - ${e.message}");
      }
    }
  }

  static Future<void> checkUserEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final querySnapshot =
          await Collections.users.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        await HiveHelper.putUID(userCredential.user!.uid);
        await HiveHelper.putisGuest(false);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(currentIndex: 0),
          ),
          (route) => false,
        );

        SaverSnackBar.show(
          context: context,
          message: AppLocalizations.of(context)!.loginSuccess,
          isTrue: true,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                (context) => EditProfilePage(
                  isEdit: false,
                  phoneNumber: "",
                  email: email,
                  isFromEmailLogin: true,
                  password: password,
                ),
          ),
          (route) => false,
        );
        SaverSnackBar.show(
          context: context,
          message:
              AppLocalizations.of(context)!.welcomePleaseCompleteYourProfile,
          isTrue: true,
        );
      }
    } catch (e) {
      try {
        Navigator.pop(context);
      } catch (dialogError) {
        if (kDebugMode) {
          print(dialogError);
        }
      }

      SaverSnackBar.show(
        context: context,
        message: "Error checking user profile",
        isTrue: false,
      );

      if (kDebugMode) {
        print("Database Error: $e");
      }
    }
  }
}
