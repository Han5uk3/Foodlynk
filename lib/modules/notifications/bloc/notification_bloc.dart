import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:saver_bbk_main/helpers/collections.dart';
import 'package:saver_bbk_main/services/app_services.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<DeleteNotificationEvent>(_deleteNotification);
    on<ClearAllNotificationsEvent>(_clearAllNotifications);
    on<FetchNotificationsEvent>(_fetchNotifications);
  }

  void _deleteNotification(
    DeleteNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await Collections.notifications.doc(event.notificationId).delete();
    } catch (e) {
      emit(NotificationDeleteError(errorMessage: e.toString()));
    }
  }

  void _clearAllNotifications(
    ClearAllNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await Collections.notifications
          .where('uid', isEqualTo: event.uid)
          .get()
          .then((value) {
            value.docs.forEach((element) {
              Collections.notifications.doc(element.id).delete();
            });
          });
      emit(NotificationsClearedSuccessfully());
    } catch (e) {
      emit(NotificationDeleteError(errorMessage: e.toString()));
    }
  }

  void _fetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) {
    try {
      Services.getUserNotifications();
      emit(NotificationsFetchedSuccessfully());
    } catch (e) {
      emit(NotificationDeleteError(errorMessage: e.toString()));
    }
  }
}
