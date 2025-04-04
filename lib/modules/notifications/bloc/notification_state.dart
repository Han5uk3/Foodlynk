part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {}

class NotificationDeleteError extends NotificationState {
  final String errorMessage;
  const NotificationDeleteError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class NotificationsClearedSuccessfully extends NotificationState {}
