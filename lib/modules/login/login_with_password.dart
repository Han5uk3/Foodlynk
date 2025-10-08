import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/services/auth_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

class LoginWithPassword extends StatefulWidget {
  const LoginWithPassword({super.key});

  @override
  State<LoginWithPassword> createState() => _LoginWithPasswordState();
}

class _LoginWithPasswordState extends State<LoginWithPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await AuthServices.checkUserEmail(
          context,
          _emailController.text.trim(),
          _passwordController.text,
        );
        setState(() {
          _isLoading = false;
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });

        String errorMessage = "Login failed";
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email.';
          setState(() {
            _isLoading = false;
          });
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.';
          setState(() {
            _isLoading = false;
          });
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
          setState(() {
            _isLoading = false;
          });
        } else if (e.code == 'user-disabled') {
          errorMessage = 'This user account has been disabled.';
          setState(() {
            _isLoading = false;
          });
        } else if (e.code == 'invalid-credential') {
          errorMessage =
              'Invalid credentials. Please check your email and password.';
          setState(() {
            _isLoading = false;
          });
        }

        SaverSnackBar.show(
          context: context,
          message: errorMessage,
          isTrue: false,
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        SaverSnackBar.show(
          context: context,
          message: "Login failed: An unexpected error occurred",
          isTrue: false,
        );
      }
    }
  }

  void _forgotPassword() {
    final String email = _emailController.text.trim();

    showDialog(
      context: context,
      builder: (context) => ForgotPasswordDialog(email: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: saverAppBar(
        AppLocalizations.of(context)!.loginWithPassword,
        context,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SaverTextField(
                  hintText: AppLocalizations.of(context)!.emailId,
                  controller: _emailController,
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterYourEmail;
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return AppLocalizations.of(
                        context,
                      )!
                          .pleaseEnterAValidEmailAddress;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SaverTextField(
                  hintText: AppLocalizations.of(context)!.password,
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .pleaseEnterYourPassword;
                    }
                    if (value.length < 6) {
                      return AppLocalizations.of(
                        context,
                      )!
                          .passwordMustBeAtLeastSixCharacters;
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: Text(
                      AppLocalizations.of(context)!.forgotPassword,
                      style: TextStyle(color: AppColor.lightGrey200),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SaverButton(
                  text: AppLocalizations.of(context)!.logIn,
                  onPressed: _isLoading ? () {} : _login,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordDialog extends StatefulWidget {
  final String email;

  const ForgotPasswordDialog({super.key, required this.email});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await AuthServices.resetPasswordWithEmail(
          context,
          _emailController.text.trim(),
        );
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to reset password: ${e.toString()}'),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        if (kDebugMode) {
          print("Reset Password Error: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      backgroundColor: theme.brightness == Brightness.dark
          ? Color.fromARGB(255, 40, 40, 50)
          : Colors.white,
      title: Row(
        children: [
          Icon(Icons.lock_reset, color: colorScheme.primary, size: 28),
          const SizedBox(width: 12),
          Text(
            AppLocalizations.of(context)!.resetPassword,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: _isSuccess
            ? _buildSuccessContent()
            : _buildFormContent(colorScheme),
      ),
      actions: _isSuccess
          ? [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.check_circle),
                label: Text(AppLocalizations.of(context)!.close),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ]
          : [
              TextButton(
                onPressed:
                    _isLoading ? null : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: _isLoading
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(AppLocalizations.of(context)!.processing),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.send,
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.resetPassword),
                        ],
                      ),
              ),
            ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildFormContent(ColorScheme colorScheme) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: colorScheme.surfaceVariant.withOpacity(0.3),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!
                        .enterYourEmailAddressAndWeWill,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: colorScheme.onSurface.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.emailAddress,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          SaverTextField(
            hintText: AppLocalizations.of(context)!.enterEmailId,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.pleaseEnterYourEmail;
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return AppLocalizations.of(context)!
                    .pleaseEnterAValidEmailAddress;
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppLocalizations.of(context)!.weWillSendASercureLinkToThisEmail,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.check, size: 50, color: Colors.green.shade700),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.resetLinkSent,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.weVeSentAPasswordResetLinkTo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _emailController.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            AppLocalizations.of(context)!
                .pleaseCheckYourInboxAndFollowTheInstructions,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
