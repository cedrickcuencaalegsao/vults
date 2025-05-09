import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../model/device_model.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DeviceBloc() : super(DeviceInitial()) {
    on<LoadDevicesRequested>(_onLoadDevicesRequested);
    on<UpdateDeviceStatusRequested>(_onUpdateDeviceStatusRequested);
  }

  Future<void> _onLoadDevicesRequested(
    LoadDevicesRequested event,
    Emitter<DeviceState> emit,
  ) async {
    try {
      emit(DeviceLoading());

      final user = _auth.currentUser;
      if (user == null) {
        emit(const DeviceError('User not authenticated'));
        return;
      }

      final devicesSnapshot =
          await _firestore
              .collection('devices')
              .where('userId', isEqualTo: user.uid)
              .get();

      final devices =
          devicesSnapshot.docs
              .map((doc) => DeviceModel.fromJson({'id': doc.id, ...doc.data()}))
              .toList();

      emit(DevicesLoaded(devices));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  Future<void> _onUpdateDeviceStatusRequested(
    UpdateDeviceStatusRequested event,
    Emitter<DeviceState> emit,
  ) async {
    try {
      await _firestore.collection('devices').doc(event.deviceId).update({
        'status': event.status.toString().split('.').last,
        'lastActive': FieldValue.serverTimestamp(),
      });

      add(LoadDevicesRequested()); // Reload devices after update
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
}
