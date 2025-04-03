part of 'food_share_bloc.dart';

sealed class FoodShareEvent extends Equatable {
  const FoodShareEvent();

  @override
  List<Object> get props => [];
}

class AddNewFoodDonationEvent extends FoodShareEvent {
  final DonationModel model;
  const AddNewFoodDonationEvent({required this.model});
  @override
  List<Object> get props => [model];
}

class AddNewBaneficiaryEvent extends FoodShareEvent {
  final DonationModel model;
  const AddNewBaneficiaryEvent({required this.model});
  @override
  List<Object> get props => [model];
}
