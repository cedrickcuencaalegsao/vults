import 'package:equatable/equatable.dart';

enum DeviceType { mobile, tablet, desktop, web }

enum DeviceStatus { active, inactive, blocked }

class DeviceModel extends Equatable {
  final String id;
  final String name;
  final DeviceType type;
  final DeviceStatus status;
  final String platform;
  final String lastIp;
  final DateTime lastActive;
  final bool isCurrent;
  final Map<String, dynamic>? metadata;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.platform,
    required this.lastIp,
    required this.lastActive,
    this.isCurrent = false,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    status,
    platform,
    lastIp,
    lastActive,
    isCurrent,
    metadata,
  ];

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: DeviceType.values.firstWhere(
        (e) => e.toString() == 'DeviceType.${json['type']}',
      ),
      status: DeviceStatus.values.firstWhere(
        (e) => e.toString() == 'DeviceStatus.${json['status']}',
      ),
      platform: json['platform'] as String,
      lastIp: json['lastIp'] as String,
      lastActive: DateTime.parse(json['lastActive'] as String),
      isCurrent: json['isCurrent'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'platform': platform,
      'lastIp': lastIp,
      'lastActive': lastActive.toIso8601String(),
      'isCurrent': isCurrent,
      'metadata': metadata,
    };
  }
}
