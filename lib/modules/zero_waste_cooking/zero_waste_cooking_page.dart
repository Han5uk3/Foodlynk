import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_selector/number_selector.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/modules/zero_waste_cooking/bloc/zero_waste_cooking_bloc.dart';
import 'package:saver_bbk_main/modules/zero_waste_cooking/saved_zero_waste_plans.dart';
import 'package:saver_bbk_main/modules/zero_waste_cooking/zero_waste_generated_result.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

class ZeroWasteCookingPage extends StatefulWidget {
  const ZeroWasteCookingPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<ZeroWasteCookingPage> createState() => _ZeroWasteCookingPageState();
}

class _ZeroWasteCookingPageState extends State<ZeroWasteCookingPage> {
  int numberOfPeople = 1;

  List<bool> checkboxValues = [false, false, false];
  TextEditingController nameController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  int? selectedType;
  int? selectedMeal;
  bool? selectedOption;
  bool checkbox1 = false;
  bool checkbox2 = false;
  bool checkbox3 = false;
  @override
  Widget build(BuildContext context) {
    List<String> options = [
      AppLocalizations.of(context)!.breakfast,
      AppLocalizations.of(context)!.lunch,
      AppLocalizations.of(context)!.dinner,
      AppLocalizations.of(context)!.snack,
    ];
    List<String> meal = [
      AppLocalizations.of(context)!.dailyMeal,
      AppLocalizations.of(context)!.familyGathering,
      AppLocalizations.of(context)!.party,
    ];
    List<String> preferances = [
      AppLocalizations.of(context)!.vegetarian,
      AppLocalizations.of(context)!.vegan,
      AppLocalizations.of(context)!.noPreferances,
    ];
    return Scaffold(
      appBar: saverAppBar(
        AppLocalizations.of(context)!.zeroWasteCooking,
        context,
        isneedtopop: true,
        iconColor: AppColor.white,
        textColor: AppColor.white,
        iswhite: false,
        onpop: widget.onBack,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmarks_sharp, color: AppColor.white),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => SavedZeroWastePlansPage())
              );
            },
          )
        ],
      ),
      body: BlocListener<ZeroWasteCookingBloc, ZeroWasteCookingState>(
        listener: (context, state) {
          if (state is GeneratedSuccessState) {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ZeroWasteRecipeResultPage(
                    genaratedPlanModel: state.generatedPortionPlan,
                    isForOnePerson:
                        state.generatedPortionPlan.data?.numberOfServings == 1,
                    selectedMeal: options[selectedMeal ?? 0],
                    enteredName: nameController.text,
                  ),
                ),
              );
            }
          }
          if (state is GeneratedFailureState) {
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    AppLocalizations.of(context)!.cookSmartReduceWaste,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.cookWhatJustEnoughForNeeds,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                SizedBox(height: 15),
                Divider(color: Colors.grey.shade200, thickness: 2),
                SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.whatAreYouCooking,
                  style: TextStyle(fontSize: 16),
                ),
                IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (index) {
                      return ListTile(
                        title: Text(
                          options[index],
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        trailing: Radio<int>(
                          value: index,
                          activeColor: AppColor.primaryColor,
                          groupValue: selectedType,
                          onChanged: (int? value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.howManyPeopleAreEating,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: NumberSelector.plain(
                        hasBorder: true,
                        showMinMax: false,
                        min: 1,
                        iconColor: Colors.grey.shade500,
                        borderRadius: 6,
                        borderColor: Colors.grey.shade300,
                        backgroundColor: AppColor.white,
                        current: numberOfPeople,
                        onUpdate: (newValue) {
                          setState(() {
                            numberOfPeople = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                numberOfPeople == 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.toWhomAreYouCooking,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),
                            Label(
                              text: "Enter Name",
                            ),
                            SizedBox(height: 8),
                            SaverTextField(
                                hintText: "Enter name",
                                controller: nameController),
                            SizedBox(height: 8),
                            Label(
                              text: "Enter Weight",
                            ),
                            SizedBox(height: 8),
                            SaverTextField(
                                hintText: "Enter weight in Kg",
                                controller: weightController),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Label(
                                  text: "Are you on a diet?",
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Checkbox(
                                      activeColor: AppColor.green,
                                      value: selectedOption == true,
                                      onChanged: (_) {
                                        setState(() {
                                          selectedOption = true;
                                        });
                                      },
                                    ),
                                    const Text("Yes"),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Row(
                                  children: [
                                    Checkbox(
                                      activeColor: AppColor.green,
                                      value: selectedOption == false,
                                      onChanged: (_) {
                                        setState(() {
                                          selectedOption = false;
                                        });
                                      },
                                    ),
                                    const Text("No"),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.toWhomAreYouCooking,
                            style: TextStyle(fontSize: 16),
                          ),
                          IntrinsicHeight(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (index) {
                                return ListTile(
                                  title: Text(
                                    meal[index],
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                  trailing: Radio<int>(
                                    value: index,
                                    activeColor: AppColor.primaryColor,
                                    groupValue: selectedMeal,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedMeal = value;
                                      });
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.dietaryPreferances,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(meal.length, (index) {
                      return ListTile(
                        title: Text(
                          preferances[index],
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        trailing: Checkbox(
                          value: checkboxValues[index],
                          activeColor: AppColor.primaryColor,
                          onChanged: (bool? value) {
                            setState(() {
                              checkboxValues[index] = value!;
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<ZeroWasteCookingBloc,
                          ZeroWasteCookingState>(
                        builder: (context, state) {
                          bool isLoading = state is GeneratingLoadingState;
                          return SaverButton(
                            isLoading: isLoading,
                            text: AppLocalizations.of(context)!.getPortionPlan,
                            onPressed: () async {
                              if (selectedType == null) {
                                SaverSnackBar.show(
                                  context: context,
                                  message: AppLocalizations.of(
                                    context,
                                  )!
                                      .pleaseSelectAType,
                                  isTrue: false,
                                );
                                return;
                              }

                              if (numberOfPeople != 1 && selectedMeal == null) {
                                SaverSnackBar.show(
                                  context: context,
                                  message: AppLocalizations.of(
                                    context,
                                  )!
                                      .pleaseSelectAMeal,
                                  isTrue: false,
                                );
                                return;
                              }

                              if (numberOfPeople == null) {
                                SaverSnackBar.show(
                                  context: context,
                                  message: "Please select a number of people",
                                  isTrue: false,
                                );
                              }
                              if (numberOfPeople == 1 &&
                                  selectedOption == null) {
                                SaverSnackBar.show(
                                  context: context,
                                  message: "Please select a diet option",
                                  isTrue: false,
                                );
                                return;
                              }
                              if (numberOfPeople == 1 &&
                                  nameController.text.isEmpty) {
                                SaverSnackBar.show(
                                  context: context,
                                  message: "Please enter a name",
                                  isTrue: false,
                                );
                                return;
                              }
                              if (numberOfPeople == 1 &&
                                  weightController.text.isEmpty) {
                                SaverSnackBar.show(
                                  context: context,
                                  message: "Please enter a weight",
                                  isTrue: false,
                                );
                                return;
                              }
                              List<String> selectedPreferences = [];
                              for (int i = 0; i < checkboxValues.length; i++) {
                                if (checkboxValues[i]) {
                                  selectedPreferences.add(preferances[i]);
                                }
                              }
                              List<String> kitchenItemNames =
                                  await Services.getKitchenItemNames(
                                selectedPreferences,
                              );
                              if (kitchenItemNames.length >= 5) {
                                context.read<ZeroWasteCookingBloc>().add(
                                      GeneratePortionPlanEvent(
                                        options[selectedType!],
                                        meal[selectedMeal ?? 0],
                                        numberOfPeople,
                                        selectedPreferences,
                                        kitchenItemNames,
                                        weightController.text,
                                        selectedOption ?? false,
                                      ),
                                    );
                              } else {
                                SaverSnackBar.show(
                                  context: context,
                                  message: AppLocalizations.of(
                                    context,
                                  )!
                                      .youDontHaveEnoughIngredients,
                                  isTrue: false,
                                );
                                return;
                              }
                            },
                            color: AppColor.primaryColor,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
