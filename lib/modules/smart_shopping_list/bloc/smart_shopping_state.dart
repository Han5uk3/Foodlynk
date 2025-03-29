part of 'smart_shopping_bloc.dart';

sealed class SmartShoppingState extends Equatable {
  const SmartShoppingState();

  @override
  List<Object> get props => [];
}

final class SmartShoppingInitial extends SmartShoppingState {}

final class CreateNewSmartShoppingListLoadingState extends SmartShoppingState {}

final class CreateNewSmartShoppingListSuccessState extends SmartShoppingState {}

final class CreateNewSmartShoppingListFailureState extends SmartShoppingState {
  final String errorMessage;

  const CreateNewSmartShoppingListFailureState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NewItemAddedToListLoadingState extends SmartShoppingState {}

class NewItemAddedToListSuccessState extends SmartShoppingState {}

class NewItemAddedToListFailureState extends SmartShoppingState {
  final String errorMessage;

  const NewItemAddedToListFailureState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class PurchasedItemLoadingState extends SmartShoppingState {}

class PurchasedItemSuccessState extends SmartShoppingState {
  final Items item;
  const PurchasedItemSuccessState({required this.item});
  @override
  List<Object> get props => [item];
}

class PurchasedItemFailureState extends SmartShoppingState {
  final String errorMessage;
  const PurchasedItemFailureState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class RemoveFromListLoadingState extends SmartShoppingState {}

class RemoveFromListSuccessState extends SmartShoppingState {}

class RemoveFromListFailureState extends SmartShoppingState {
  final String errorMessage;
  const RemoveFromListFailureState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class MovingItemLoadingState extends SmartShoppingState {}

class MovingItemSuccessState extends SmartShoppingState {
  final bool isFromParentSide;

  const MovingItemSuccessState({required this.isFromParentSide});
  @override
  List<Object> get props => [isFromParentSide];
}

class MovingItemFailureState extends SmartShoppingState {
  final String errorMessage;
  const MovingItemFailureState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ListNameChangedLoadingState extends SmartShoppingState {}

class ListNameChangedSuccessState extends SmartShoppingState {
  final String listnewName;
  const ListNameChangedSuccessState({required this.listnewName});
  @override
  List<Object> get props => [listnewName];
}

class ListNameChangedFailureState extends SmartShoppingState {
  final String errorMessage;
  const ListNameChangedFailureState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
