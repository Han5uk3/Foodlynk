import 'package:flutter/material.dart';
import 'package:saver_bbk_main/api/app_apis.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/models/smart_recipe_model.dart';
import 'package:saver_bbk_main/modules/smart_recipes/smart_recipe_result_page.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenerateRecipePage extends StatefulWidget {
  final VoidCallback onBack;
  const GenerateRecipePage({super.key, required this.onBack});

  @override
  _GenerateRecipePageState createState() => _GenerateRecipePageState();
}

class _GenerateRecipePageState extends State<GenerateRecipePage> {
  final List<String> _selectedIngredients = [];
  List<String> _kitchenItemNames = [];
  bool _isLoading = true;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _fetchKitchenItems();
  }

  Future<void> _fetchKitchenItems() async {
    setState(() {
      _isLoading = true;
    });

    List<String> kitchenItemNames = await Services.getKitchenItemNames([]);

    setState(() {
      _kitchenItemNames = kitchenItemNames.toSet().toList();
      _isLoading = false;
    });
  }

  void _toggleIngredient(String ingredient) {
    setState(() {
      if (_selectedIngredients.contains(ingredient)) {
        _selectedIngredients.remove(ingredient);
      } else {
        _selectedIngredients.add(ingredient);
      }
    });
  }

  Future<void> _generateRecipe() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      GenerateSmartRecipe result = await AppApis().generateSmartRecipe(
        _selectedIngredients,
      );

      if (!mounted) return;

      if (result.success == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => RecipeResultsPage(
                  recipeData: result,
                  onBack: () => Navigator.pop(context),
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate recipe. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: saverAppBar(
        AppLocalizations.of(context)!.generateNewRecipe,
        context,
        isneedtopop: true,
        onpop: widget.onBack,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(
                    context,
                  )!.noteYourKitchenMustHaveAtLeastFive,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.selectIngredients,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                if (_isLoading)
                  SaverLoader()
                else if (_kitchenItemNames.isEmpty)
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.noKitchenItemsAvailable,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _kitchenItemNames.map((ingredient) {
                          return FilterChip(
                            backgroundColor:
                                _selectedIngredients.contains(ingredient)
                                    ? Colors.blue[200]
                                    : Colors.grey[200],
                            label: Text(
                              ingredient,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            selected: _selectedIngredients.contains(ingredient),
                            onSelected:
                                (selected) => _toggleIngredient(ingredient),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                  ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (_selectedIngredients.length >= 5 && !_isGenerating)
                            ? _generateRecipe
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child:
                        _isGenerating
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              AppLocalizations.of(context)!.generateRecipe,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),

          if (_isGenerating)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SaverLoader(),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.generatingYourRecipe,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
