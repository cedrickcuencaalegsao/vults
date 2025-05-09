import 'package:cloud_firestore/cloud_firestore.dart';

enum DeviceType { mobile, tablet, desktop, web }

enum DeviceStatus { active, inactive }

class DeviceModel {
  final String id;
  final String name;
  final DeviceType type;
  final DeviceStatus status;
  final DateTime lastActive;
  final String userId;

  DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.lastActive,
    required this.userId,
  });

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
      lastActive: (json['lastActive'] as Timestamp).toDate(),
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'lastActive': Timestamp.fromDate(lastActive),
      'userId': userId,
    };
  }
}
