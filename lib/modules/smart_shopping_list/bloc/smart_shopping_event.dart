part of 'smart_shopping_bloc.dart';

sealed class SmartShoppingEvent extends Equatable {
  const SmartShoppingEvent();

  @override
  List<Object> get props => [];
}

class CreateNewSmartShoppingEvent extends SmartShoppingEvent {
  final String listName;
  const CreateNewSmartShoppingEvent({required this.listName});
  @override
  List<Object> get props => [listName];
}

class AddNewItemSmartShoppingEvent extends SmartShoppingEvent {
  final String listId;
  final String itemName;
  final String itemUnit;
  final int itemQuantity;
  const AddNewItemSmartShoppingEvent({
    required this.listId,
    required this.itemName,
    required this.itemUnit,
    required this.itemQuantity,
  });
  @override
  List<Object> get props => [listId, itemName, itemUnit, itemQuantity];
}

class MarkAsPurchasedSmartShoppingEvent extends SmartShoppingEvent {
  final String listId;
  final Items item;
  final File? image;
  const MarkAsPurchasedSmartShoppingEvent({
    required this.listId,
    required this.item,
    this.image,
  });
  @override
  List<Object> get props => [listId, item];
}

class UpdateUnitEvent extends SmartShoppingEvent {
  final String unit;
  const UpdateUnitEvent({required this.unit});
  @override
  List<Object> get props => [unit];
}

class MoveFromKitchenToSmartListEvent extends SmartShoppingEvent {
  final String listId;
  final Items item;
  final bool isFromParentSide;
  const MoveFromKitchenToSmartListEvent({
    required this.listId,
    required this.item,
    required this.isFromParentSide,
  });
  @override
  List<Object> get props => [listId, item, isFromParentSide];
}

class UpdateSmartShopingListNameEvent extends SmartShoppingEvent {
  final String listId;
  final String newName;
  const UpdateSmartShopingListNameEvent({
    required this.newName,
    required this.listId,
  });
  @override
  List<Object> get props => [newName];
}

class RemoveItemSmartShoppingEvent extends SmartShoppingEvent {
  final String listId;
  final String itemId;
  const RemoveItemSmartShoppingEvent({
    required this.listId,
    required this.itemId,
  });
  @override
  List<Object> get props => [listId, itemId];
}

class GenerateItemAddSmartShoppingListEvent extends SmartShoppingEvent {
  final String recipeName;
  final int numberOfServings;
  const GenerateItemAddSmartShoppingListEvent(
      {required this.recipeName, required this.numberOfServings});
  @override
  List<Object> get props => [recipeName, numberOfServings];
}
