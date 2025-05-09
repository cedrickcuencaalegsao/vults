import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part 'account_settings.event.dart';
part 'account_settings.state.dart';

class AccountSettingsBloc
    extends Bloc<AccountSettingsEvent, AccountSettingsState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AccountSettingsBloc() : super(AccountSettingsInitial()) {
    on<LoadAccountSettings>(_onLoadAccountSettings);
    on<UpdateAccountSettings>(_onUpdateAccountSettings);
    on<UpdateProfilePicture>(_onUpdateProfilePicture);
  }

  Future<void> _onLoadAccountSettings(
    LoadAccountSettings event,
    Emitter<AccountSettingsState> emit,
  ) async {
    try {
      emit(AccountSettingsLoading());

      final user = _auth.currentUser;
      if (user == null) {
        emit(const AccountSettingsError('User not authenticated'));
        return;
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        emit(const AccountSettingsError('User profile not found'));
        return;
      }

      final data = doc.data()!;
      emit(
        AccountSettingsLoaded(
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          email: user.email ?? '',
          isVerified: user.emailVerified,
          photoUrl: user.photoURL,
          phoneNumber: user.phoneNumber,
          pin: data['pin'] ?? '', // Added pin
        ),
      );
    } catch (e) {
      emit(AccountSettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateAccountSettings(
    UpdateAccountSettings event,
    Emitter<AccountSettingsState> emit,
  ) async {
    try {
      emit(AccountSettingsLoading());

      final user = _auth.currentUser;
      if (user == null) {
        emit(const AccountSettingsError('User not authenticated'));
        return;
      }

      // Update Firestore data
      await _firestore.collection('users').doc(user.uid).update({
        'firstName': event.firstName,
        'lastName': event.lastName,
        'phoneNumber': event.phoneNumber,
      });

      // Update email if changed
      if (user.email != event.email) {
        await user.verifyBeforeUpdateEmail(event.email);
      }

      emit(const AccountSettingsUpdated('Profile updated successfully'));
      add(LoadAccountSettings()); // Reload settings
    } catch (e) {
      emit(AccountSettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateProfilePicture(
    UpdateProfilePicture event,
    Emitter<AccountSettingsState> emit,
  ) async {
    try {
      emit(AccountSettingsLoading());

      final user = _auth.currentUser;
      if (user == null) {
        emit(const AccountSettingsError('User not authenticated'));
        return;
      }

      // Update profile picture logic here
      // You'll need to implement Firebase Storage upload

      emit(const AccountSettingsUpdated('Profile picture updated'));
      add(LoadAccountSettings()); // Reload settings
    } catch (e) {
      emit(AccountSettingsError(e.toString()));
    }
  }
}
