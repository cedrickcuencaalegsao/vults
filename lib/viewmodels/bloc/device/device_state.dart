part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DevicesLoaded extends DeviceState {
  final List<DeviceModel> devices;

  const DevicesLoaded(this.devices);

  @override
  List<Object> get props => [devices];
}

class DeviceAdded extends DeviceState {
  final DeviceModel device;

  const DeviceAdded(this.device);

  @override
  List<Object> get props => [device];
}

class DeviceRemoved extends DeviceState {
  final String deviceId;

  const DeviceRemoved(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class DeviceStatusUpdated extends DeviceState {
  final String deviceId;
  final DeviceStatus status;

  const DeviceStatusUpdated({required this.deviceId, required this.status});

  @override
  List<Object> get props => [deviceId, status];
}

class DeviceBlocked extends DeviceState {
  final String deviceId;

  const DeviceBlocked(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class DeviceUnblocked extends DeviceState {
  final String deviceId;

  const DeviceUnblocked(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class DeviceError extends DeviceState {
  final String message;

  const DeviceError(this.message);

  @override
  List<Object> get props => [message];
}
