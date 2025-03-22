part of 'kitchen_manager_bloc.dart';

sealed class KitchenManagerState extends Equatable {
  const KitchenManagerState();

  @override
  List<Object> get props => [];
}

final class KitchenManagerInitial extends KitchenManagerState {}

final class AddNewStateLoading extends KitchenManagerState {
  final bool isLoading;
  const AddNewStateLoading({required this.isLoading});
  @override
  List<Object> get props => [isLoading];
}

final class AddNewStateSuccess extends KitchenManagerState {}

final class AddNewStateError extends KitchenManagerState {
  final String errorMessage;
  const AddNewStateError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
