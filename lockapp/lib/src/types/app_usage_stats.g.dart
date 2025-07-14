// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_usage_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUsageStatsImpl _$$AppUsageStatsImplFromJson(Map<String, dynamic> json) =>
    _$AppUsageStatsImpl(
      id: json['id'] as String,
      childUserId: json['childUserId'] as String,
      packageName: json['packageName'] as String,
      appName: json['appName'] as String,
      appIcon: json['appIcon'] as String,
      date: DateTime.parse(json['date'] as String),
      totalTimeInForeground: (json['totalTimeInForeground'] as num).toInt(),
      launchCount: (json['launchCount'] as num).toInt(),
      firstTimeStamp: DateTime.parse(json['firstTimeStamp'] as String),
      lastTimeStamp: DateTime.parse(json['lastTimeStamp'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AppUsageStatsImplToJson(_$AppUsageStatsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childUserId': instance.childUserId,
      'packageName': instance.packageName,
      'appName': instance.appName,
      'appIcon': instance.appIcon,
      'date': instance.date.toIso8601String(),
      'totalTimeInForeground': instance.totalTimeInForeground,
      'launchCount': instance.launchCount,
      'firstTimeStamp': instance.firstTimeStamp.toIso8601String(),
      'lastTimeStamp': instance.lastTimeStamp.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$DailyUsageSummaryImpl _$$DailyUsageSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$DailyUsageSummaryImpl(
  id: json['id'] as String,
  childUserId: json['childUserId'] as String,
  date: DateTime.parse(json['date'] as String),
  totalScreenTime: (json['totalScreenTime'] as num).toInt(),
  totalAppLaunches: (json['totalAppLaunches'] as num).toInt(),
  uniqueAppsUsed: (json['uniqueAppsUsed'] as num).toInt(),
  mostUsedApp: json['mostUsedApp'] as String,
  mostUsedAppTime: (json['mostUsedAppTime'] as num).toInt(),
  topApps: (json['topApps'] as List<dynamic>)
      .map((e) => AppUsageStats.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$DailyUsageSummaryImplToJson(
  _$DailyUsageSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'childUserId': instance.childUserId,
  'date': instance.date.toIso8601String(),
  'totalScreenTime': instance.totalScreenTime,
  'totalAppLaunches': instance.totalAppLaunches,
  'uniqueAppsUsed': instance.uniqueAppsUsed,
  'mostUsedApp': instance.mostUsedApp,
  'mostUsedAppTime': instance.mostUsedAppTime,
  'topApps': instance.topApps,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_$WeeklyUsageReportImpl _$$WeeklyUsageReportImplFromJson(
  Map<String, dynamic> json,
) => _$WeeklyUsageReportImpl(
  id: json['id'] as String,
  childUserId: json['childUserId'] as String,
  weekStart: DateTime.parse(json['weekStart'] as String),
  weekEnd: DateTime.parse(json['weekEnd'] as String),
  totalScreenTime: (json['totalScreenTime'] as num).toInt(),
  averageDailyScreenTime: (json['averageDailyScreenTime'] as num).toInt(),
  totalAppLaunches: (json['totalAppLaunches'] as num).toInt(),
  averageDailyLaunches: (json['averageDailyLaunches'] as num).toInt(),
  dailySummaries: (json['dailySummaries'] as List<dynamic>)
      .map((e) => DailyUsageSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  topAppsWeekly: (json['topAppsWeekly'] as List<dynamic>)
      .map((e) => AppUsageStats.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$WeeklyUsageReportImplToJson(
  _$WeeklyUsageReportImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'childUserId': instance.childUserId,
  'weekStart': instance.weekStart.toIso8601String(),
  'weekEnd': instance.weekEnd.toIso8601String(),
  'totalScreenTime': instance.totalScreenTime,
  'averageDailyScreenTime': instance.averageDailyScreenTime,
  'totalAppLaunches': instance.totalAppLaunches,
  'averageDailyLaunches': instance.averageDailyLaunches,
  'dailySummaries': instance.dailySummaries,
  'topAppsWeekly': instance.topAppsWeekly,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
