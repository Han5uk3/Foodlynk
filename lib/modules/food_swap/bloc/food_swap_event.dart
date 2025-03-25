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
