part of 'food_share_bloc.dart';

sealed class FoodShareState extends Equatable {
  const FoodShareState();

  @override
  List<Object> get props => [];
}

final class FoodShareInitial extends FoodShareState {}

final class NewDonationLoadingState extends FoodShareState {}

final class NewDonationSuccessState extends FoodShareState {}

final class NewDonationFailedState extends FoodShareState {
  final String errorMessage;
  const NewDonationFailedState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

final class NewBenificiaryLoadingState extends FoodShareState {}

final class NewBenificiarySuccessState extends FoodShareState {}

final class NewBenificiaryFailedState extends FoodShareState {
  final String errorMessage;
  const NewBenificiaryFailedState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
