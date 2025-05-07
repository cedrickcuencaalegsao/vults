part of 'auth_bloc.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => []; // Changed from Object to Object?
}

class AuthLoginRequested extends AuthEvent {
  final String pin;

  const AuthLoginRequested({required this.pin});

  @override
  List<Object> get props => [pin];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String firstName;
  final String? middleName;
  final String lastName;
  final DateTime? birthday;
  final String pin;

  const AuthRegisterRequested({
    required this.email,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.birthday,
    required this.pin,
  });

  @override
  List<Object?> get props => [
    email,
    firstName,
    middleName,
    lastName,
    birthday,
    pin,
  ];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
