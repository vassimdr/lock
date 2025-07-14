// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_control_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppBlockRuleImpl _$$AppBlockRuleImplFromJson(Map<String, dynamic> json) =>
    _$AppBlockRuleImpl(
      id: json['id'] as String,
      parentUserId: json['parentUserId'] as String,
      childUserId: json['childUserId'] as String,
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      appIcon: json['appIcon'] as String,
      isBlocked: json['isBlocked'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      reason: json['reason'] as String?,
      blockedUntil: json['blockedUntil'] == null
          ? null
          : DateTime.parse(json['blockedUntil'] as String),
    );

Map<String, dynamic> _$$AppBlockRuleImplToJson(_$AppBlockRuleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentUserId': instance.parentUserId,
      'childUserId': instance.childUserId,
      'packageName': instance.packageName,
      'appName': instance.appName,
      'appIcon': instance.appIcon,
      'isBlocked': instance.isBlocked,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'reason': instance.reason,
      'blockedUntil': instance.blockedUntil?.toIso8601String(),
    };

_$TimeRestrictionImpl _$$TimeRestrictionImplFromJson(
  Map<String, dynamic> json,
) => _$TimeRestrictionImpl(
  id: json['id'] as String,
  parentUserId: json['parentUserId'] as String,
  childUserId: json['childUserId'] as String,
  packageName: json['packageName'] as String,
  appName: json['appName'] as String,
  appIcon: json['appIcon'] as String,
  isEnabled: json['isEnabled'] as bool,
  dailyTimeLimit: (json['dailyTimeLimit'] as num).toInt(),
  allowedDays: (json['allowedDays'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$TimeRestrictionImplToJson(
  _$TimeRestrictionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'parentUserId': instance.parentUserId,
  'childUserId': instance.childUserId,
  'packageName': instance.packageName,
  'appName': instance.appName,
  'appIcon': instance.appIcon,
  'isEnabled': instance.isEnabled,
  'dailyTimeLimit': instance.dailyTimeLimit,
  'allowedDays': instance.allowedDays,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_$AppControlSummaryImpl _$$AppControlSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$AppControlSummaryImpl(
  id: json['id'] as String,
  childUserId: json['childUserId'] as String,
  date: DateTime.parse(json['date'] as String),
  totalBlockedApps: (json['totalBlockedApps'] as num).toInt(),
  totalTimeRestrictedApps: (json['totalTimeRestrictedApps'] as num).toInt(),
  totalBlockAttempts: (json['totalBlockAttempts'] as num).toInt(),
  mostBlockedApps: (json['mostBlockedApps'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$AppControlSummaryImplToJson(
  _$AppControlSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'childUserId': instance.childUserId,
  'date': instance.date.toIso8601String(),
  'totalBlockedApps': instance.totalBlockedApps,
  'totalTimeRestrictedApps': instance.totalTimeRestrictedApps,
  'totalBlockAttempts': instance.totalBlockAttempts,
  'mostBlockedApps': instance.mostBlockedApps,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_$BlockAttemptLogImpl _$$BlockAttemptLogImplFromJson(
  Map<String, dynamic> json,
) => _$BlockAttemptLogImpl(
  id: json['id'] as String,
  childUserId: json['childUserId'] as String,
  packageName: json['packageName'] as String,
  appName: json['appName'] as String,
  attemptTime: DateTime.parse(json['attemptTime'] as String),
  blockReason: json['blockReason'] as String,
  wasBlocked: json['wasBlocked'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$BlockAttemptLogImplToJson(
  _$BlockAttemptLogImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'childUserId': instance.childUserId,
  'packageName': instance.packageName,
  'appName': instance.appName,
  'attemptTime': instance.attemptTime.toIso8601String(),
  'blockReason': instance.blockReason,
  'wasBlocked': instance.wasBlocked,
  'createdAt': instance.createdAt.toIso8601String(),
};
