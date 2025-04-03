part of 'kitchen_manager_bloc.dart';

sealed class KitchenManagerEvent extends Equatable {
  const KitchenManagerEvent();

  @override
  List<Object> get props => [];
}

class AddNewItemEvent extends KitchenManagerEvent {
  final Items item;
  final File? imageFile;
  const AddNewItemEvent({required this.item, this.imageFile});
  @override
  List<Object> get props => [item, imageFile ?? File];
}

class RemoveItemEvent extends KitchenManagerEvent {
  final String itemId;
  final bool beforeExpiry;
  final int itemCount;
  final bool? inSideParentPage;
  const RemoveItemEvent({
    required this.itemId,
    required this.beforeExpiry,
    required this.itemCount,
    this.inSideParentPage,
  });
  @override
  List<Object> get props => [
    itemId,
    beforeExpiry,
    itemCount,
    inSideParentPage ?? false,
  ];
}
