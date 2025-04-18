import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({super.key});

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  final TextEditingController recipeController = TextEditingController();
  final TextEditingController serveController = TextEditingController();

  @override
  void dispose() {
    recipeController.dispose();
    serveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColor.white,
                    AppColor.lightGreen,
                    AppColor.primaryColor,
                  ],
                ),
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height / 3.5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Icon(
            Icons.dinner_dining_rounded,
            size: 150,
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 22),
        Label(text: "What Recipe are you looking for?"),
        const SizedBox(height: 10),
        SaverTextField(
          isDark: true,
          borderColor: AppColor.black,
          hintText: "Enter your recipe name",
          validator: (value) => value == null || value.isEmpty
              ? "Please enter a recipe name"
              : null,
          controller: recipeController,
        ),
        const SizedBox(height: 22),
        Label(text: "How many people are you serving?"),
        const SizedBox(height: 10),
        SaverTextField(
          isDark: true,
          borderColor: AppColor.black,
          hintText: "Enter number of serves",
          validator: (value) => value == null || value.isEmpty
              ? "Please enter number of serves"
              : null,
          controller: serveController,
        ),
        const SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SaverOutlineButton(
                borderColor: Colors.black,
                textColor: Colors.black,
                text: "Back",
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SaverButton(
                color: Colors.black,
                text: "Next",
                onPressed: () {
                  // Add navigation or validation logic
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
