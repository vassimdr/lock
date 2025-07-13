// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pairing_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PairingRequestImpl _$$PairingRequestImplFromJson(Map<String, dynamic> json) =>
    _$PairingRequestImpl(
      id: json['id'] as String,
      parentUserId: json['parentUserId'] as String,
      parentDeviceId: json['parentDeviceId'] as String,
      parentName: json['parentName'] as String,
      qrCode: json['qrCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isUsed: json['isUsed'] as bool? ?? false,
      childUserId: json['childUserId'] as String?,
      childDeviceId: json['childDeviceId'] as String?,
      childName: json['childName'] as String?,
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
    );

Map<String, dynamic> _$$PairingRequestImplToJson(
  _$PairingRequestImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'parentUserId': instance.parentUserId,
  'parentDeviceId': instance.parentDeviceId,
  'parentName': instance.parentName,
  'qrCode': instance.qrCode,
  'createdAt': instance.createdAt.toIso8601String(),
  'expiresAt': instance.expiresAt.toIso8601String(),
  'isUsed': instance.isUsed,
  'childUserId': instance.childUserId,
  'childDeviceId': instance.childDeviceId,
  'childName': instance.childName,
  'acceptedAt': instance.acceptedAt?.toIso8601String(),
};
