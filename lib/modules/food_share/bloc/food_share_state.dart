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

// Update these state classes in your food_share_bloc.dart file
class RequestAddedSuccessState extends FoodShareState {
  final bool isIntrested;
  final String itemId; // Add this field

  const RequestAddedSuccessState({
    required this.isIntrested,
    required this.itemId,
  });
}

class RequestAddedFailedState extends FoodShareState {
  final String errorMessage;
  final String itemId; // Add this field

  const RequestAddedFailedState({
    required this.errorMessage,
    required this.itemId,
  });
}

final class AcceptRequestLoadingState extends FoodShareState {}

final class AcceptRequestSuccessState extends FoodShareState {}

final class AcceptRequestFailedState extends FoodShareState {
  final String errorMessage;
  const AcceptRequestFailedState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
