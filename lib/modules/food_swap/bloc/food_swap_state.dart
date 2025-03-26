part of 'food_swap_bloc.dart';

sealed class FoodSwapState extends Equatable {
  const FoodSwapState();

  @override
  List<Object> get props => [];
}

final class FoodSwapInitial extends FoodSwapState {}

class FoodSwapLoading extends FoodSwapState {
  final bool isLoading;
  const FoodSwapLoading({required this.isLoading});
  @override
  List<Object> get props => [isLoading];
}

class FoodSwapError extends FoodSwapState {
  final String errorMessage;
  const FoodSwapError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class FoodSwapSuccess extends FoodSwapState {}

class FoodSwapUpdateSuccessState extends FoodSwapState {}

class FoodSwapUpdateError extends FoodSwapState {
  final String errorMessage;
  const FoodSwapUpdateError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class DeleteFromFoodSwapLoadingState extends FoodSwapState {
  final bool isLoading;
  const DeleteFromFoodSwapLoadingState({required this.isLoading});
  @override
  List<Object> get props => [isLoading];
}

class DeleteFromFoodSwapError extends FoodSwapState {
  final String errorMessage;
  const DeleteFromFoodSwapError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class DeleteFromFoodSwapSuccessState extends FoodSwapState {}

class AcceptFoodSwapLoadingState extends FoodSwapState {
  final bool isLoading;
  const AcceptFoodSwapLoadingState({required this.isLoading});
  @override
  List<Object> get props => [isLoading];
}

class AcceptFoodSwapError extends FoodSwapState {
  final String errorMessage;
  const AcceptFoodSwapError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class AcceptFoodSwapSuccessState extends FoodSwapState {}

class FoodSwapRequestDeclainedSuccessState extends FoodSwapState {}

class FoodSwapRequestDeclinedError extends FoodSwapState {
  final String errorMessage;
  const FoodSwapRequestDeclinedError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
