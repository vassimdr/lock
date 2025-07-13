// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  ownerId: json['ownerId'] as String,
  parentId: json['parentId'] as String?,
  deviceInfo: json['deviceInfo'] as String,
  isOnline: json['isOnline'] as bool? ?? false,
  lastSeen: DateTime.parse(json['lastSeen'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  settings: json['settings'] as Map<String, dynamic>?,
  installedApps:
      (json['installedApps'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'ownerId': instance.ownerId,
      'parentId': instance.parentId,
      'deviceInfo': instance.deviceInfo,
      'isOnline': instance.isOnline,
      'lastSeen': instance.lastSeen.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'settings': instance.settings,
      'installedApps': instance.installedApps,
    };
