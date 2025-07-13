import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'device_model.g.dart';

enum DeviceType {
  @JsonValue('parent_device')
  parentDevice,
  @JsonValue('child_device')
  childDevice,
}

enum DeviceStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('blocked')
  blocked,
  @JsonValue('pending')
  pending,
}

@JsonSerializable()
class DeviceModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'device_name')
  final String deviceName;
  @JsonKey(name: 'device_id')
  final String deviceId;
  @JsonKey(name: 'device_type')
  final DeviceType deviceType;
  final DeviceStatus status;
  @JsonKey(name: 'os_version')
  final String? osVersion;
  @JsonKey(name: 'app_version')
  final String? appVersion;
  @JsonKey(name: 'device_model')
  final String? deviceModel;
  @JsonKey(name: 'is_online')
  final bool isOnline;
  @JsonKey(name: 'last_seen', fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime lastSeen;
  @JsonKey(name: 'fcm_token')
  final String? fcmToken;
  final Map<String, dynamic>? settings;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'created_at', fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;
  @JsonKey(name: 'updated_at', fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime updatedAt;

  const DeviceModel({
    required this.id,
    required this.userId,
    required this.deviceName,
    required this.deviceId,
    required this.deviceType,
    required this.status,
    this.osVersion,
    this.appVersion,
    this.deviceModel,
    this.isOnline = false,
    required this.lastSeen,
    this.fcmToken,
    this.settings,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Firestore document ID is separate
    return json;
  }

  /// Create from Firestore document
  factory DeviceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return DeviceModel.fromJson(data);
  }

  DeviceModel copyWith({
    String? id,
    String? userId,
    String? deviceName,
    String? deviceId,
    DeviceType? deviceType,
    DeviceStatus? status,
    String? osVersion,
    String? appVersion,
    String? deviceModel,
    bool? isOnline,
    DateTime? lastSeen,
    String? fcmToken,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceName: deviceName ?? this.deviceName,
      deviceId: deviceId ?? this.deviceId,
      deviceType: deviceType ?? this.deviceType,
      status: status ?? this.status,
      osVersion: osVersion ?? this.osVersion,
      appVersion: appVersion ?? this.appVersion,
      deviceModel: deviceModel ?? this.deviceModel,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      fcmToken: fcmToken ?? this.fcmToken,
      settings: settings ?? this.settings,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Helper functions for Firestore Timestamp conversion
DateTime _timestampFromJson(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  } else if (timestamp is String) {
    return DateTime.parse(timestamp);
  } else if (timestamp is int) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
  return DateTime.now();
}

dynamic _timestampToJson(DateTime dateTime) {
  return Timestamp.fromDate(dateTime);
}

extension DeviceTypeExtension on DeviceType {
  String get value {
    switch (this) {
      case DeviceType.parentDevice:
        return 'parent_device';
      case DeviceType.childDevice:
        return 'child_device';
    }
  }

  static DeviceType fromString(String value) {
    switch (value) {
      case 'parent_device':
        return DeviceType.parentDevice;
      case 'child_device':
        return DeviceType.childDevice;
      default:
        throw ArgumentError('Invalid device type: $value');
    }
  }
}

extension DeviceStatusExtension on DeviceStatus {
  String get value {
    switch (this) {
      case DeviceStatus.active:
        return 'active';
      case DeviceStatus.inactive:
        return 'inactive';
      case DeviceStatus.blocked:
        return 'blocked';
      case DeviceStatus.pending:
        return 'pending';
    }
  }

  static DeviceStatus fromString(String value) {
    switch (value) {
      case 'active':
        return DeviceStatus.active;
      case 'inactive':
        return DeviceStatus.inactive;
      case 'blocked':
        return DeviceStatus.blocked;
      case 'pending':
        return DeviceStatus.pending;
      default:
        throw ArgumentError('Invalid device status: $value');
    }
  }
} 