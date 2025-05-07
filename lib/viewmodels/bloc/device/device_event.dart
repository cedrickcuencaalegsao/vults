part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

class LoadDevicesRequested extends DeviceEvent {}

class AddDeviceRequested extends DeviceEvent {
  final DeviceModel device;

  const AddDeviceRequested(this.device);

  @override
  List<Object> get props => [device];
}

class RemoveDeviceRequested extends DeviceEvent {
  final String deviceId;

  const RemoveDeviceRequested(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class UpdateDeviceStatusRequested extends DeviceEvent {
  final String deviceId;
  final DeviceStatus status;

  const UpdateDeviceStatusRequested({
    required this.deviceId,
    required this.status,
  });

  @override
  List<Object> get props => [deviceId, status];
}

class BlockDeviceRequested extends DeviceEvent {
  final String deviceId;

  const BlockDeviceRequested(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class UnblockDeviceRequested extends DeviceEvent {
  final String deviceId;

  const UnblockDeviceRequested(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}
