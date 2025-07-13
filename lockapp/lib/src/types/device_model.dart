import 'package:json_annotation/json_annotation.dart';

part 'device_model.g.dart';

@JsonSerializable()
class DeviceModel {
  final String id;
  final String name;
  final String type; // 'parent_device' or 'child_device'
  final String ownerId; // User ID
  final String? parentId; // Parent device ID for child devices
  final String deviceInfo; // Device information (model, OS version, etc.)
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? settings;
  final List<String> installedApps;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.ownerId,
    this.parentId,
    required this.deviceInfo,
    this.isOnline = false,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
    this.settings,
    this.installedApps = const [],
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);

  DeviceModel copyWith({
    String? id,
    String? name,
    String? type,
    String? ownerId,
    String? parentId,
    String? deviceInfo,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? settings,
    List<String>? installedApps,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      ownerId: ownerId ?? this.ownerId,
      parentId: parentId ?? this.parentId,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      settings: settings ?? this.settings,
      installedApps: installedApps ?? this.installedApps,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceModel &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.ownerId == ownerId &&
        other.parentId == parentId &&
        other.deviceInfo == deviceInfo &&
        other.isOnline == isOnline &&
        other.lastSeen == lastSeen &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        ownerId.hashCode ^
        parentId.hashCode ^
        deviceInfo.hashCode ^
        isOnline.hashCode ^
        lastSeen.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'DeviceModel(id: $id, name: $name, type: $type, ownerId: $ownerId, parentId: $parentId, deviceInfo: $deviceInfo, isOnline: $isOnline, lastSeen: $lastSeen, createdAt: $createdAt, updatedAt: $updatedAt, settings: $settings, installedApps: $installedApps)';
  }

  // Helper methods
  bool get isParentDevice => type == 'parent_device';
  bool get isChildDevice => type == 'child_device';
  
  String get statusText => isOnline ? 'Çevrimiçi' : 'Çevrimdışı';
  
  Duration get lastSeenDuration => DateTime.now().difference(lastSeen);
  
  String get lastSeenText {
    final duration = lastSeenDuration;
    if (duration.inMinutes < 1) {
      return 'Şimdi';
    } else if (duration.inHours < 1) {
      return '${duration.inMinutes} dakika önce';
    } else if (duration.inDays < 1) {
      return '${duration.inHours} saat önce';
    } else {
      return '${duration.inDays} gün önce';
    }
  }
} 