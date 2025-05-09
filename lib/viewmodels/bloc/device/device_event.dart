part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object?> get props => [];
}

class LoadDevicesRequested extends DeviceEvent {}

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
