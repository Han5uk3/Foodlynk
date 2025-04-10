part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class DeleteNotificationEvent extends NotificationEvent {
  final String notificationId;
  const DeleteNotificationEvent({required this.notificationId});
  @override
  List<Object> get props => [notificationId];
}

class ClearAllNotificationsEvent extends NotificationEvent {
  final String uid;
  const ClearAllNotificationsEvent({required this.uid});
  @override
  List<Object> get props => [uid];
}

class FetchNotificationsEvent extends NotificationEvent {}
