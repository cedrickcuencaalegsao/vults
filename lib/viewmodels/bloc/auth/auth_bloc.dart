import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // TODO: Replace with actual Firebase authentication
      final user = User(
        id: 'temp_id',
        email: 'temp@email.com',
        firstName: 'John',
        lastName: 'Doe',
        pin: event.pin,
        createdAt: DateTime.now(),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // TODO: Replace with actual Firebase registration
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: event.email,
        firstName: event.firstName,
        middleName: event.middleName,
        lastName: event.lastName,
        birthday: event.birthday,
        pin: event.pin,
        createdAt: DateTime.now(),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: Clear local storage and Firebase auth
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // TODO: Check local storage and Firebase auth state
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
