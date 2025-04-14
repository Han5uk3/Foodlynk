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

class RequestAddedSuccessState extends FoodShareState {
  final bool isIntrested;
  final String itemId;

  const RequestAddedSuccessState({
    required this.isIntrested,
    required this.itemId,
  });
}

class RequestAddedFailedState extends FoodShareState {
  final String errorMessage;
  final String itemId;

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

class DeclineRequestLoadingState extends FoodShareState {}

class DeclineRequestSuccessState extends FoodShareState {}

class DeclineRequestFailedState extends FoodShareState {
  final String errorMessage;
  const DeclineRequestFailedState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class DeleteRequestLoadingState extends FoodShareState {}

class DeleteRequestSuccessState extends FoodShareState {}

class DeleteRequestFailedState extends FoodShareState {
  final String errorMessage;
  const DeleteRequestFailedState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
