part of 'zero_waste_cooking_bloc.dart';

sealed class ZeroWasteCookingState extends Equatable {
  const ZeroWasteCookingState();

  @override
  List<Object> get props => [];
}

final class ZeroWasteCookingInitial extends ZeroWasteCookingState {}

final class GeneratingLoadingState extends ZeroWasteCookingState {
  final bool isLoading;
  const GeneratingLoadingState({required this.isLoading});
  @override
  List<Object> get props => [isLoading];
}

final class GeneratedSuccessState extends ZeroWasteCookingState {
  final GenaratedProteinPlanModel generatedPortionPlan;
  const GeneratedSuccessState({required this.generatedPortionPlan});
  @override
  List<Object> get props => [generatedPortionPlan];
}

final class GeneratedFailureState extends ZeroWasteCookingState {
  final String errorMessage;

  const GeneratedFailureState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
