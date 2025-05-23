import 'package:equatable/equatable.dart';

enum UserStatus { active, inactive, blocked }

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? profilePicture;
  final DateTime? birthday;
  final String pin;
  final double balance;
  final List<String> deviceIds;
  final Map<String, dynamic> settings;
  final UserStatus status;
  final DateTime createdAt;
  final DateTime? lastLogin;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.profilePicture,
    this.birthday,
    required this.pin,
    this.balance = 0.0,
    this.deviceIds = const [],
    this.settings = const {},
    this.status = UserStatus.active,
    required this.createdAt,
    this.lastLogin,
  });

  String get fullName =>
      middleName?.isNotEmpty == true
          ? '$firstName $middleName $lastName'
          : '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String,
      profilePicture: json['profilePicture'] as String?,
      birthday:
          json['birthday'] != null
              ? DateTime.parse(json['birthday'] as String)
              : null,
      pin: json['pin'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      deviceIds: List<String>.from(json['deviceIds'] ?? []),
      settings: Map<String, dynamic>.from(json['settings'] ?? {}),
      status: UserStatus.values.firstWhere(
        (e) => e.toString() == 'UserStatus.${json['status']}',
        orElse: () => UserStatus.active,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin:
          json['lastLogin'] != null
              ? DateTime.parse(json['lastLogin'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'profilePicture': profilePicture,
      'birthday': birthday?.toIso8601String(),
      'pin': pin,
      'balance': balance,
      'deviceIds': deviceIds,
      'settings': settings,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? middleName,
    String? lastName,
    String? profilePicture,
    DateTime? birthday,
    String? pin,
    double? balance,
    List<String>? deviceIds,
    Map<String, dynamic>? settings,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      birthday: birthday ?? this.birthday,
      pin: pin ?? this.pin,
      balance: balance ?? this.balance,
      deviceIds: deviceIds ?? this.deviceIds,
      settings: settings ?? this.settings,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    middleName,
    lastName,
    profilePicture,
    birthday,
    pin,
    balance,
    deviceIds,
    settings,
    status,
    createdAt,
    lastLogin,
  ];
}
