import 'package:equatable/equatable.dart';

enum NotificationPreference { all, important, none }

class SettingsModel extends Equatable {
  final String language;
  final NotificationPreference notificationPreference;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final Map<String, bool> transactionAlerts;

  const SettingsModel({
    this.language = 'en',
    this.notificationPreference = NotificationPreference.all,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.transactionAlerts = const {
      'large': true,
      'suspicious': true,
      'failed': true,
    },
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      language: json['language'] as String? ?? 'en',
      notificationPreference: NotificationPreference.values.firstWhere(
        (e) =>
            e.toString() ==
            'NotificationPreference.${json['notificationPreference']}',
        orElse: () => NotificationPreference.all,
      ),
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      transactionAlerts: Map<String, bool>.from(
        json['transactionAlerts'] ??
            {'large': true, 'suspicious': true, 'failed': true},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'notificationPreference':
          notificationPreference.toString().split('.').last,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
      'transactionAlerts': transactionAlerts,
    };
  }

  SettingsModel copyWith({
    String? language,
    NotificationPreference? notificationPreference,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    Map<String, bool>? transactionAlerts,
  }) {
    return SettingsModel(
      language: language ?? this.language,
      notificationPreference:
          notificationPreference ?? this.notificationPreference,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      transactionAlerts: transactionAlerts ?? this.transactionAlerts,
    );
  }

  @override
  List<Object?> get props => [
    language,
    notificationPreference,
    emailNotifications,
    pushNotifications,
    smsNotifications,
    transactionAlerts,
  ];
}
