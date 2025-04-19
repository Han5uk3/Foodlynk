part of 'zero_waste_cooking_bloc.dart';

sealed class ZeroWasteCookingEvent extends Equatable {
  const ZeroWasteCookingEvent();

  @override
  List<Object> get props => [];
}

class GeneratePortionPlanEvent extends ZeroWasteCookingEvent {
  final String whatareyoucooking;
  final String towhomareyoucooking;
  final int numberOfServings;
  final List<String> dietaryPreferences;
  final List<String> ingredients;
  final String weight;
  final bool isDieting;

  const GeneratePortionPlanEvent(
    this.whatareyoucooking,
    this.towhomareyoucooking,
    this.numberOfServings,
    this.dietaryPreferences,
    this.ingredients,
    this.weight,
    this.isDieting,
  );
  @override
  List<Object> get props => [
    whatareyoucooking,
    towhomareyoucooking,
    numberOfServings,
    dietaryPreferences,
    ingredients,
    weight,
    isDieting,
  ];
}
