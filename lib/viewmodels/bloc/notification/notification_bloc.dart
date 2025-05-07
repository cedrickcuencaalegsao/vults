import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotificationsRequested>(_onLoadNotificationsRequested);
    on<MarkNotificationAsReadRequested>(_onMarkNotificationAsReadRequested);
    on<DeleteNotificationRequested>(_onDeleteNotificationRequested);
    on<ClearAllNotificationsRequested>(_onClearAllNotificationsRequested);
  }

  Future<void> _onLoadNotificationsRequested(
    LoadNotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      final notifications = [
        NotificationModel(
          id: '1',
          title: 'Transaction Completed',
          message: 'Your transfer of \$100 has been completed',
          timestamp: DateTime.now(),
          type: NotificationType.transaction,
          priority: NotificationPriority.high,
          isRead: false,
        ),
        NotificationModel(
          id: '2',
          title: 'Security Alert',
          message: 'New device logged in to your account',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: NotificationType.security,
          priority: NotificationPriority.high,
          isRead: true,
        ),
        NotificationModel(
          id: '3',
          title: 'System Update',
          message: 'New features available',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: NotificationType.system,
          priority: NotificationPriority.medium,
          isRead: false,
        ),
      ];
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkNotificationAsReadRequested(
    MarkNotificationAsReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is NotificationsLoaded) {
        final currentState = state as NotificationsLoaded;
        final updatedNotifications =
            currentState.notifications.map((notification) {
              if (notification.id == event.notificationId) {
                return NotificationModel(
                  id: notification.id,
                  title: notification.title,
                  message: notification.message,
                  timestamp: notification.timestamp,
                  type: notification.type,
                  priority: notification.priority,
                  isRead: true,
                  metadata: notification.metadata,
                );
              }
              return notification;
            }).toList();
        emit(NotificationsLoaded(updatedNotifications));
        emit(NotificationMarkedAsRead(event.notificationId));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onDeleteNotificationRequested(
    DeleteNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is NotificationsLoaded) {
        final currentState = state as NotificationsLoaded;
        final updatedNotifications =
            currentState.notifications
                .where(
                  (notification) => notification.id != event.notificationId,
                )
                .toList();
        emit(NotificationsLoaded(updatedNotifications));
        emit(NotificationDeleted(event.notificationId));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onClearAllNotificationsRequested(
    ClearAllNotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationsLoaded([]));
      emit(AllNotificationsCleared());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
