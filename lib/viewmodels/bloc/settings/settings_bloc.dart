import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/settings_model.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettingsRequested>(_onLoadSettingsRequested);
    on<UpdateSettingsRequested>(_onUpdateSettingsRequested);
    on<UpdateNotificationPreferencesRequested>(
      _onUpdateNotificationPreferencesRequested,
    );
    on<UpdateLanguageRequested>(_onUpdateLanguageRequested);
  }

  Future<void> _onLoadSettingsRequested(
    LoadSettingsRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      // Simulate API call - your teammate will replace with Firebase
      await Future.delayed(const Duration(milliseconds: 500));
      final settings = SettingsModel(
        language: 'en',
        notificationPreference: NotificationPreference.all,
        emailNotifications: true,
        pushNotifications: true,
        smsNotifications: false,
        transactionAlerts: {'large': true, 'suspicious': true, 'failed': true},
      );
      emit(SettingsLoaded(settings: settings));
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
          transactionAlerts: event.transactionAlerts,
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
}
