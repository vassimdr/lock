// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  deviceName: json['device_name'] as String,
  deviceId: json['device_id'] as String,
  deviceType: $enumDecode(_$DeviceTypeEnumMap, json['device_type']),
  status: $enumDecode(_$DeviceStatusEnumMap, json['status']),
  osVersion: json['os_version'] as String?,
  appVersion: json['app_version'] as String?,
  deviceModel: json['device_model'] as String?,
  isOnline: json['is_online'] as bool? ?? false,
  lastSeen: _timestampFromJson(json['last_seen']),
  fcmToken: json['fcm_token'] as String?,
  settings: json['settings'] as Map<String, dynamic>?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  createdAt: _timestampFromJson(json['created_at']),
  updatedAt: _timestampFromJson(json['updated_at']),
);

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'device_name': instance.deviceName,
      'device_id': instance.deviceId,
      'device_type': _$DeviceTypeEnumMap[instance.deviceType]!,
      'status': _$DeviceStatusEnumMap[instance.status]!,
      'os_version': instance.osVersion,
      'app_version': instance.appVersion,
      'device_model': instance.deviceModel,
      'is_online': instance.isOnline,
      'last_seen': _timestampToJson(instance.lastSeen),
      'fcm_token': instance.fcmToken,
      'settings': instance.settings,
      'metadata': instance.metadata,
      'created_at': _timestampToJson(instance.createdAt),
      'updated_at': _timestampToJson(instance.updatedAt),
    };

const _$DeviceTypeEnumMap = {
  DeviceType.parentDevice: 'parent_device',
  DeviceType.childDevice: 'child_device',
};

const _$DeviceStatusEnumMap = {
  DeviceStatus.active: 'active',
  DeviceStatus.inactive: 'inactive',
  DeviceStatus.blocked: 'blocked',
  DeviceStatus.pending: 'pending',
};
