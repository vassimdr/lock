// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  role: UserModel._roleFromJson(json['role'] as String),
  profileImageUrl: json['profile_image_url'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  isActive: json['is_active'] as bool? ?? true,
  parentUserId: json['parent_user_id'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'role': UserModel._roleToJson(instance.role),
  'profile_image_url': instance.profileImageUrl,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'is_active': instance.isActive,
  'parent_user_id': instance.parentUserId,
  'metadata': instance.metadata,
};
