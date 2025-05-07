part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationsRequested extends NotificationEvent {}

class MarkNotificationAsReadRequested extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsReadRequested(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class DeleteNotificationRequested extends NotificationEvent {
  final String notificationId;

  const DeleteNotificationRequested(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class ClearAllNotificationsRequested extends NotificationEvent {}
