import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String userId;
  final String email;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? profilePicture;
  final DateTime? lastUpdated;
  final Map<String, dynamic>? preferences;

  const ProfileModel({
    required this.userId,
    required this.email,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.profilePicture,
    this.lastUpdated,
    this.preferences,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
    firstName,
    middleName,
    lastName,
    profilePicture,
    lastUpdated,
    preferences,
  ];
}
