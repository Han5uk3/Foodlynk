import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/models/smart_recipe_model.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeResultsPage extends StatelessWidget {
  final GenerateSmartRecipe recipeData;
  final VoidCallback onBack;

  const RecipeResultsPage({
    super.key,
    required this.recipeData,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: saverAppBar(
        AppLocalizations.of(context)!.generatedRecipes,
        context,
      ),
      body: _generatedTiles(),
    );
  }

  Widget _generatedTiles() {
    if (recipeData.data?.recipes == null || recipeData.data!.recipes!.isEmpty) {
      return const Center(child: Text('No recipes available'));
    }

    return ListView.builder(
      itemCount: recipeData.data?.recipes?.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final recipe = recipeData.data?.recipes?[index];
        return Card(
          color: AppColor.white,
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recipe?.imageUrl != null && recipe!.imageUrl!.isNotEmpty)
                Image.network(
                  recipe.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.restaurant, size: 50),
                      ),
                    );
                  },
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe?.foodName ?? "Unknown Recipe",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (recipe?.cookingTime != null)
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            recipe!.cookingTime!,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    if (recipe?.steps != null && recipe!.steps!.isNotEmpty) ...[
                      const Text(
                        "Step by Step instruction",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...recipe.steps!.map(
                        (step) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "• ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(child: Text(step.whatToDo ?? "")),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
