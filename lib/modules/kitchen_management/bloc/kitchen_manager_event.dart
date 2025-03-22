part of 'kitchen_manager_bloc.dart';

sealed class KitchenManagerEvent extends Equatable {
  const KitchenManagerEvent();

  @override
  List<Object> get props => [];
}

class AddNewItemEvent extends KitchenManagerEvent {
  final String itemName;
  final String category;
  final String unitName;
  final int quantity;
  final DateTime expiredDate;

  const AddNewItemEvent({
    required this.itemName,
    required this.category,
    required this.unitName,
    required this.quantity,
    required this.expiredDate,
  });
  @override
  List<Object> get props => [
    itemName,
    category,
    unitName,
    quantity,
    expiredDate,
  ];
}

class RemoveItemEvent extends KitchenManagerEvent {
  final String itemId;
  final bool beforeExpiry;
  final int itemCount;
  const RemoveItemEvent({
    required this.itemId,
    required this.beforeExpiry,
    required this.itemCount,
  });
  @override
  List<Object> get props => [itemId, beforeExpiry, itemCount];
}
