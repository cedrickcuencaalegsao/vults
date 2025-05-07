import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/device_model.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(DeviceInitial()) {
    on<LoadDevicesRequested>(_onLoadDevicesRequested);
    on<AddDeviceRequested>(_onAddDeviceRequested);
    on<RemoveDeviceRequested>(_onRemoveDeviceRequested);
    on<UpdateDeviceStatusRequested>(_onUpdateDeviceStatusRequested);
    on<BlockDeviceRequested>(_onBlockDeviceRequested);
    on<UnblockDeviceRequested>(_onUnblockDeviceRequested);
  }

  void _onLoadDevicesRequested(
    LoadDevicesRequested event,
    Emitter<DeviceState> emit,
  ) async {
    emit(DeviceLoading());
    try {
      // Here you would typically load devices from your storage service
      await Future.delayed(const Duration(milliseconds: 500));
      final devices = [
        DeviceModel(
          id: '1',
          name: 'iPhone 12',
          type: DeviceType.mobile,
          status: DeviceStatus.active,
          platform: 'iOS',
          lastIp: '192.168.1.1',
          lastActive: DateTime.now(),
        ),
        DeviceModel(
          id: '2',
          name: 'MacBook Pro',
          type: DeviceType.desktop,
          status: DeviceStatus.active,
          platform: 'macOS',
          lastIp: '192.168.1.2',
          lastActive: DateTime.now(),
        ),
      ];
      emit(DevicesLoaded(devices));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  void _onAddDeviceRequested(
    AddDeviceRequested event,
    Emitter<DeviceState> emit,
  ) async {
    try {
      // Here you would typically add the device to your storage service
      await Future.delayed(const Duration(milliseconds: 500));
      emit(DeviceAdded(event.device));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  void _onRemoveDeviceRequested(
    RemoveDeviceRequested event,
    Emitter<DeviceState> emit,
  ) async {
    try {
      // Here you would typically remove the device from your storage service
      await Future.delayed(const Duration(milliseconds: 500));
      emit(DeviceRemoved(event.deviceId));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  void _onUpdateDeviceStatusRequested(
    UpdateDeviceStatusRequested event,
    Emitter<DeviceState> emit,
  ) async {
    try {
      // Here you would typically update the device status in your storage service
      await Future.delayed(const Duration(milliseconds: 500));
      emit(DeviceStatusUpdated(deviceId: event.deviceId, status: event.status));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  void _onBlockDeviceRequested(
    BlockDeviceRequested event,
    Emitter<DeviceState> emit,
  ) async {
    try {
      // Here you would typically block the device in your storage service
      await Future.delayed(const Duration(milliseconds: 500));
      emit(DeviceBlocked(event.deviceId));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  void _onUnblockDeviceRequested(
    UnblockDeviceRequested event,
    Emitter<DeviceState> emit,
  ) async {
    try {
      // Here you would typically unblock the device in your storage service
      await Future.delayed(const Duration(milliseconds: 500));
      emit(DeviceUnblocked(event.deviceId));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }
}
