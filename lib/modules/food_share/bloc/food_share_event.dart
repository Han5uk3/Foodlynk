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

class IntrestedFoodShareEvent extends FoodShareEvent {
  final String id;
  final bool isInterested;
  final String type;

  const IntrestedFoodShareEvent({
    required this.id,
    required this.type,
    required this.isInterested,
  });
  @override
  List<Object> get props => [id, type, isInterested];
}

class DeleteFoodShareRequest extends FoodShareEvent {
  final String reqId;
  const DeleteFoodShareRequest({required this.reqId});
  @override
  List<Object> get props => [reqId];
}

class AcceptFoodShareRequest extends FoodShareEvent {
  final String reqId;
  final String reciverUid;
  final String fcmToken;
  final String type;
  final CommunityBloc? communityBloc;

  const AcceptFoodShareRequest({
    required this.reqId,
    required this.reciverUid,
    required this.fcmToken,
    required this.type,
    this.communityBloc,
  });
  @override
  List<Object> get props => [reqId, fcmToken];
}

class DeclineFoodShareRequest extends FoodShareEvent {
  final String reqId;
  final String intrestedId;
  const DeclineFoodShareRequest({
    required this.reqId,
    required this.intrestedId,
  });
  @override
  List<Object> get props => [reqId, intrestedId];
}
