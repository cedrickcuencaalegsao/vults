part of 'account_settings_bloc.dart';

@immutable
abstract class AccountSettingsState extends Equatable {
  const AccountSettingsState();

  @override
  List<Object?> get props => [];
}

class AccountSettingsInitial extends AccountSettingsState {}

class AccountSettingsLoading extends AccountSettingsState {}

class AccountSettingsLoaded extends AccountSettingsState {
  final String firstName;
  final String lastName;
  final String email;
  final bool isVerified;
  final String? photoUrl;
  final String? phoneNumber;
  final String? pin; // Added pin field

  const AccountSettingsLoaded({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.isVerified = false,
    this.photoUrl,
    this.phoneNumber,
    this.pin, // Added to constructor
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    isVerified,
    photoUrl,
    phoneNumber,
    pin, // Added to props
  ];

  AccountSettingsLoaded copyWith({
    String? firstName,
    String? lastName,
    String? email,
    bool? isVerified,
    String? photoUrl,
    String? phoneNumber,
    String? pin, // Added to copyWith
  }) {
    return AccountSettingsLoaded(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pin: pin ?? this.pin, // Added to return
    );
  }
}

class AccountSettingsUpdated extends AccountSettingsState {
  final String message;

  const AccountSettingsUpdated([
    this.message = 'Settings updated successfully',
  ]);

  @override
  List<Object> get props => [message];
}

class AccountSettingsError extends AccountSettingsState {
  final String message;

  const AccountSettingsError(this.message);

  @override
  List<Object> get props => [message];
}
