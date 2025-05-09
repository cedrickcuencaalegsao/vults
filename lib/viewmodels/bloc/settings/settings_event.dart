part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsRequested extends SettingsEvent {}

class UpdateSettingsRequested extends SettingsEvent {
  final SettingsModel settings;

  const UpdateSettingsRequested(this.settings);

  @override
  List<Object> get props => [settings];
}

class UpdateNotificationPreferencesRequested extends SettingsEvent {
  final NotificationPreference preference;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool transactionAlerts; // Changed from Map to bool

  const UpdateNotificationPreferencesRequested({
    required this.preference,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.smsNotifications,
    required this.transactionAlerts,
  });

  @override
  List<Object> get props => [
    preference,
    emailNotifications,
    pushNotifications,
    smsNotifications,
    transactionAlerts,
  ];
}

class UpdateLanguageRequested extends SettingsEvent {
  final String language;

  const UpdateLanguageRequested(this.language);

  @override
  List<Object> get props => [language];
}

class SignOutRequested extends SettingsEvent {
  @override
  List<Object?> get props => [];
}
