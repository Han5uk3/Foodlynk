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

class AcceptFoodSwapEvent extends FoodSwapEvent {
  final String? swapId;
  final String? uid;
  final String? acceptedSwapItem;
  final String? pickupLocation;
  final DateTime? pickupDate;
  final DateTime? pickupTime;
  const AcceptFoodSwapEvent({
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

class DeclineFoodSwapEvent extends FoodSwapEvent {
  final String swapId;
  final int reqId;
  const DeclineFoodSwapEvent({required this.reqId, required this.swapId});
  @override
  List<Object> get props => [reqId, swapId];
}
