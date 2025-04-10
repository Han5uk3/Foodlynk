import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/styles/colors.dart';


class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        "Terms & Conditions",
        context,
        isneedtopop: true,
        iswhite: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.justify,
                style: TextStyle(color: AppColor.lightGrey200, fontSize: 14),
                "Welcome to Saver App! By using this application, you agree to be bound by these Terms and Conditions. Please read them carefully before accessing or using the services.",
              ),
              _buildtermscontent(
                "1. Acceptance of Terms",
                "By downloading, accessing, or using Saver App, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you should not use the app. Your continued use of the app signifies your acceptance of these terms.",
              ),
              _buildtermscontent(
                "2.  Description of Services",
                "Saver App offers a variety of features including food sharing and food donation, a smart recipe generator based on available ingredients and nutritional needs, zero-waste cooking ideas, kitchen inventory management, and a shopping list tool. Additionally, the app includes a challenge system where users can earn virtual coins upon successful completion of tasks following specific instructions.",
              ),
              _buildtermscontent(
                "3.User Responsibilities",
                "Users are responsible for ensuring that any food they share or donate is safe and suitable for consumption. Misuse of app features, such as submitting false data or attempting to exploit the challenge system, is strictly prohibited. Users must also maintain respectful interactions with others and keep their account details secure. In case of unauthorized account access, users are expected to report the issue promptly.",
              ),
              _buildtermscontent(
                "4.Virtual Rewards",
                "Coins earned through challenges in Saver App are virtual in nature and have no real-world monetary value. These coins are intended for engagement within the app only and cannot be redeemed for cash or external rewards. Saver App reserves the right to alter, suspend, or remove the coin system at any time without prior notice.",
              ),
              _buildtermscontent(
                "5. Intellectual Property",
                "All design elements, logos, content, and features of Saver App are the exclusive intellectual property of its developers. Users may not copy, modify, distribute, or use any content from the app without written permission from the developers.",
              ),
              _buildtermscontent(
                "6. Privacy",
                "Saver App is committed to protecting your personal information. Please refer to our Privacy Policy for details on how we collect, use, and protect your data.",
              ),
              _buildtermscontent(
                "7. Modifications to Terms",
                "Saver App may update these Terms and Conditions from time to time to reflect changes in features or legal requirements. Notifications of updates will be shared within the app, and continued use of the app indicates acceptance of the revised terms.",
              ),
              _buildtermscontent(
                "8. Limitation of Liability",
                "The app is provided “as is” and without warranties of any kind. Saver App will not be held liable for any damages, losses, or issues arising from the use of the app, including but not limited to food-related incidents, inaccurate recipe suggestions, or data loss.",
              ),
              _buildtermscontent(
                "9. Termination",
                "We reserve the right to suspend or terminate access to Saver App for users who violate these Terms and Conditions or engage in inappropriate, unsafe, or abusive behavior within the platform.",
              ),
              _buildtermscontent(
                "10. Contact Us",
                "If you have any questions or concerns about these Terms and Conditions, please contact us at",
              ),
              SizedBox(height: 12),
              Text(
                "Email: [email]",
                style: TextStyle(color: AppColor.lightGrey200, fontSize: 14),
              ),
              Text(
                "Phone: [phone number]",
                style: TextStyle(color: AppColor.lightGrey200, fontSize: 14),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  _buildtermscontent(head, desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Label(text: head, isBold: true),
        SizedBox(height: 20),
        Text(
          textAlign: TextAlign.justify,
          style: TextStyle(color: AppColor.lightGrey200, fontSize: 14),
          desc,
        ),
      ],
    );
  }
}
