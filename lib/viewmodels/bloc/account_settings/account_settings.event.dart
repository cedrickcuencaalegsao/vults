part of 'account_settings_bloc.dart';

@immutable
abstract class AccountSettingsEvent extends Equatable {
  const AccountSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccountSettings extends AccountSettingsEvent {}

class UpdateAccountSettings extends AccountSettingsEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;

  const UpdateAccountSettings({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, phoneNumber];
}

class UpdateProfilePicture extends AccountSettingsEvent {
  final String imagePath;

  const UpdateProfilePicture(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class UpdateSecurityPin extends AccountSettingsEvent {
  final String pin;

  const UpdateSecurityPin({required this.pin});

  @override
  List<Object> get props => [pin];
}
