import 'package:equatable/equatable.dart';

enum NotificationPreference { all, none, custom }

class SettingsModel extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool transactionAlerts;
  final NotificationPreference notificationPreference;
  final String language;

  const SettingsModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.notificationPreference = NotificationPreference.all,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = true,
    this.transactionAlerts = true,
    this.language = 'en',
  });

  SettingsModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    bool? transactionAlerts,
    NotificationPreference? notificationPreference,
    String? language,
  }) {
    return SettingsModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      transactionAlerts: transactionAlerts ?? this.transactionAlerts,
      notificationPreference:
          notificationPreference ?? this.notificationPreference,
      language: language ?? this.language,
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      notificationPreference:
          json['notificationPreference'] == 'none'
              ? NotificationPreference.none
              : json['notificationPreference'] == 'custom'
              ? NotificationPreference.custom
              : NotificationPreference.all,
      emailNotifications: json['emailNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? true,
      transactionAlerts: json['transactionAlerts'] ?? true,
      language: json['language'] ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'notificationPreference':
          notificationPreference.toString().split('.').last,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
      'transactionAlerts': transactionAlerts,
      'language': language,
    };
  }

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    email,
    emailNotifications,
    pushNotifications,
    smsNotifications,
    transactionAlerts,
    notificationPreference,
    language,
  ];
}
