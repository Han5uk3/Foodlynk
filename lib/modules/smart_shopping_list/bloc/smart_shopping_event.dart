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
  const MarkAsPurchasedSmartShoppingEvent({
    required this.listId,
    required this.item,
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
