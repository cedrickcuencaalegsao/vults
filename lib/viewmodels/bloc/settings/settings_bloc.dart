import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/settings_model.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettingsRequested>(_onLoadSettings);
    on<UpdateSettingsRequested>(_onUpdateSettingsRequested);
    on<UpdateNotificationPreferencesRequested>(
      _onUpdateNotificationPreferencesRequested,
    );
    on<UpdateLanguageRequested>(_onUpdateLanguageRequested);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onLoadSettings(
    LoadSettingsRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(SettingsLoading());

      final user = _auth.currentUser;
      if (user == null) {
        emit(const SettingsError('User not authenticated'));
        return;
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        emit(const SettingsError('User settings not found'));
        return;
      }

      final settings = SettingsModel.fromJson({
        'userId': user.uid,
        ...doc.data()!,
      });

      emit(SettingsLoaded(settings: settings)); // Fixed: Added named parameter
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateSettingsRequested(
    UpdateSettingsRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      // Simulate API call - your teammate will replace with Firebase
      await Future.delayed(const Duration(milliseconds: 500));
      if (state is SettingsLoaded) {
        emit(SettingsUpdated(event.settings));
        emit(SettingsLoaded(settings: event.settings));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateNotificationPreferencesRequested(
    UpdateNotificationPreferencesRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      if (state is SettingsLoaded) {
        final currentSettings = (state as SettingsLoaded).settings;
        final updatedSettings = currentSettings.copyWith(
          notificationPreference: event.preference,
          emailNotifications: event.emailNotifications,
          pushNotifications: event.pushNotifications,
          smsNotifications: event.smsNotifications,
          transactionAlerts: event.transactionAlerts, // Now matches bool type
        );
        emit(SettingsUpdated(updatedSettings));
        emit(SettingsLoaded(settings: updatedSettings));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateLanguageRequested(
    UpdateLanguageRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      if (state is SettingsLoaded) {
        final currentSettings = (state as SettingsLoaded).settings;
        final updatedSettings = currentSettings.copyWith(
          language: event.language,
        );
        emit(SettingsUpdated(updatedSettings));
        emit(SettingsLoaded(settings: updatedSettings));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(SettingsLoading()); // Add loading state
      await _auth.signOut();
      emit(SettingsSignedOut());
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
