part of 'food_swap_bloc.dart';

sealed class FoodSwapEvent extends Equatable {
  const FoodSwapEvent();

  @override
  List<Object> get props => [];
}

class AddItemToFoodSwapEvent extends FoodSwapEvent {
  final Items item;
  const AddItemToFoodSwapEvent({required this.item});
  @override
  List<Object> get props => [item];
}

class UpdateItemInFoodSwapEvent extends FoodSwapEvent {
  final Items item;
  const UpdateItemInFoodSwapEvent({required this.item});
  @override
  List<Object> get props => [item];
}

class RemoveItemFromFoodSwapEvent extends FoodSwapEvent {
  final String swapId;
  const RemoveItemFromFoodSwapEvent({required this.swapId});
  @override
  List<Object> get props => [swapId];
}

class RequestFoodSwapEvent extends FoodSwapEvent {
  final String? swapId;
  final String? uid;
  final String? acceptedSwapItem;
  final String? pickupLocation;
  final DateTime? pickupDate;
  final DateTime? pickupTime;
  const RequestFoodSwapEvent({
    this.swapId,
    this.uid,
    this.acceptedSwapItem,
    this.pickupLocation,
    this.pickupDate,
    this.pickupTime,
  });
  @override
  List<Object> get props => [
    swapId ?? "",
    uid ?? "",
    acceptedSwapItem ?? "",
    pickupLocation ?? "",
    pickupDate ?? "",
    pickupTime ?? "",
  ];
}

class AcceptedFoodSwapRequestEvent extends FoodSwapEvent {
  final String swapId;
  final String reciverUid;
  final CommunityBloc? communityBloc;
  const AcceptedFoodSwapRequestEvent({
    required this.swapId,
    required this.reciverUid,
    required this.communityBloc,
  });
  @override
  List<Object> get props => [swapId];
}

class DeclineFoodSwapEvent extends FoodSwapEvent {
  final String swapId;
  final int reqId;
  const DeclineFoodSwapEvent({required this.reqId, required this.swapId});
  @override
  List<Object> get props => [reqId, swapId];
}
