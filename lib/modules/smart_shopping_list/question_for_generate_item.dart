import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/bloc/smart_shopping_bloc.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/generated_items.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

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
                    Color(0xFFF9FFFA),
                    Color(0xFFE1F5E6),
                    Color(0xFF6FCF97),
                  ],
                  stops: [0.2, 0.6, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Icon(
            Icons.dinner_dining_rounded,
            size: 70,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.recipePlanner,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.letsCreateYourShoppinList,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocConsumer<SmartShoppingBloc, SmartShoppingState>(
      listener: (context, state) {
        if (state is GenerateSmartShoppingListItemsSuccessState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeneratedShoppingListView(
                  shoppingList: state.generatedSmartShoppingList,
                  recipeName: state.recipeName,
                ),
              ));
        }
        if (state is GenerateSmartShoppingListItemsFailureState) {
          SaverSnackBar.show(
              context: context, message: state.errorMessage, isTrue: false);
        }
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormField(
                icon: Icons.restaurant_menu,
                label: AppLocalizations.of(context)!.whatRecipeAreYouLookingFor,
                hintText: AppLocalizations.of(context)!.pleaseEnterARecipeName,
                controller: recipeController,
              ),
              const SizedBox(height: 24),
              _buildFormField(
                icon: Icons.people_alt_rounded,
                label: AppLocalizations.of(context)!.howManyPeopleAreYouServing,
                hintText: AppLocalizations.of(context)!.enterNumberOfServes,
                controller: serveController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              _buildButtons(state),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormField({
    required IconData icon,
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColor.primaryColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: SaverTextField(
            isDark: true,
            borderColor: Colors.transparent,
            hintText: hintText,
            keyboardType: keyboardType,
            validator: (value) => value == null || value.isEmpty
                ? "This field is required"
                : null,
            controller: controller,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(SmartShoppingState state) {
    bool isLoading = state is GenerateSmartShoppingListItemsLoadingState;

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 320) {
        return Row(
          children: [
            SaverOutlineButton(
              borderColor: Colors.black54,
              textColor: Colors.black54,
              text: AppLocalizations.of(context)!.cancel,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: SaverButton(
                isLoading: isLoading,
                color: AppColor.primaryColor,
                text: AppLocalizations.of(context)!.generateList,
                onPressed: () => _validateAndSubmit(context),
              ),
            ),
          ],
        );
      }

      return Row(
        children: [
          SaverOutlineButton(
            borderColor: Colors.black54,
            textColor: Colors.black54,
            text: AppLocalizations.of(context)!.cancel,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 16),
          SaverButton(
            isLoading: isLoading,
            color: AppColor.primaryColor,
            text: AppLocalizations.of(context)!.generateList,
            onPressed: () => _validateAndSubmit(context),
          ),
        ],
      );
    });
  }

  void _validateAndSubmit(BuildContext context) {
    if (recipeController.text.isEmpty) {
      SaverSnackBar.show(
          context: context,
          message: AppLocalizations.of(context)!.pleaseEnterARecipeName,
          isTrue: false);
      return;
    }

    if (serveController.text.isEmpty) {
      SaverSnackBar.show(
          context: context,
          message: AppLocalizations.of(context)!.pleaseEnterNumberOfServes,
          isTrue: false);
      return;
    }

    try {
      int serves = int.parse(serveController.text);
      if (serves <= 0) {
        SaverSnackBar.show(
            context: context,
            message: AppLocalizations.of(context)!
                .numberOfServesMustBeGreaterThanZero,
            isTrue: false);
        return;
      }

      context.read<SmartShoppingBloc>().add(
            GenerateItemAddSmartShoppingListEvent(
              recipeName: recipeController.text,
              numberOfServings: serves,
            ),
          );
    } catch (e) {
      SaverSnackBar.show(
          context: context,
          message: "Please enter a valid number",
          isTrue: false);
    }
  }
}
