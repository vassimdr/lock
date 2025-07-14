import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'app_usage_stats.freezed.dart';
part 'app_usage_stats.g.dart';

@freezed
class AppUsageStats with _$AppUsageStats {
  const factory AppUsageStats({
    required String id,
    required String childUserId,
    required String packageName,
    required String appName,
    required String appIcon, // Base64 encoded icon
    required DateTime date,
    required int totalTimeInForeground, // milliseconds
    required int launchCount,
    required DateTime firstTimeStamp,
    required DateTime lastTimeStamp,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppUsageStats;

  const AppUsageStats._();

  factory AppUsageStats.fromJson(Map<String, dynamic> json) =>
      _$AppUsageStatsFromJson(json);

  Map<String, dynamic> toJson() => _$AppUsageStatsToJson(this);

  // Firestore conversion methods
  factory AppUsageStats.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUsageStats(
      id: doc.id,
      childUserId: data['childUserId'] ?? '',
      packageName: data['packageName'] ?? '',
      appName: data['appName'] ?? '',
      appIcon: data['appIcon'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      totalTimeInForeground: data['totalTimeInForeground'] ?? 0,
      launchCount: data['launchCount'] ?? 0,
      firstTimeStamp: (data['firstTimeStamp'] as Timestamp).toDate(),
      lastTimeStamp: (data['lastTimeStamp'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'childUserId': childUserId,
      'packageName': packageName,
      'appName': appName,
      'appIcon': appIcon,
      'date': Timestamp.fromDate(date),
      'totalTimeInForeground': totalTimeInForeground,
      'launchCount': launchCount,
      'firstTimeStamp': Timestamp.fromDate(firstTimeStamp),
      'lastTimeStamp': Timestamp.fromDate(lastTimeStamp),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Helper methods
  String get formattedDuration {
    final duration = Duration(milliseconds: totalTimeInForeground);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours}s ${minutes}d ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}d ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  double get usagePercentage {
    // Calculate percentage of day (24 hours = 86400000 ms)
    return (totalTimeInForeground / 86400000.0) * 100;
  }
}

@freezed
class DailyUsageSummary with _$DailyUsageSummary {
  const factory DailyUsageSummary({
    required String id,
    required String childUserId,
    required DateTime date,
    required int totalScreenTime, // milliseconds
    required int totalAppLaunches,
    required int uniqueAppsUsed,
    required String mostUsedApp,
    required int mostUsedAppTime,
    required List<AppUsageStats> topApps,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DailyUsageSummary;

  const DailyUsageSummary._();

  factory DailyUsageSummary.fromJson(Map<String, dynamic> json) =>
      _$DailyUsageSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$$DailyUsageSummaryImplToJson(this as _$DailyUsageSummaryImpl);

  // Firestore conversion methods
  factory DailyUsageSummary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyUsageSummary(
      id: doc.id,
      childUserId: data['childUserId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      totalScreenTime: data['totalScreenTime'] ?? 0,
      totalAppLaunches: data['totalAppLaunches'] ?? 0,
      uniqueAppsUsed: data['uniqueAppsUsed'] ?? 0,
      mostUsedApp: data['mostUsedApp'] ?? '',
      mostUsedAppTime: data['mostUsedAppTime'] ?? 0,
      topApps: (data['topApps'] as List<dynamic>?)
          ?.map((e) => AppUsageStats.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'childUserId': childUserId,
      'date': Timestamp.fromDate(date),
      'totalScreenTime': totalScreenTime,
      'totalAppLaunches': totalAppLaunches,
      'uniqueAppsUsed': uniqueAppsUsed,
      'mostUsedApp': mostUsedApp,
      'mostUsedAppTime': mostUsedAppTime,
      'topApps': topApps.map((e) => e.toFirestore()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Helper methods
  String get formattedTotalScreenTime {
    final duration = Duration(milliseconds: totalScreenTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}s ${minutes}d';
    } else {
      return '${minutes}d';
    }
  }
}

@freezed
class WeeklyUsageReport with _$WeeklyUsageReport {
  const factory WeeklyUsageReport({
    required String id,
    required String childUserId,
    required DateTime weekStart,
    required DateTime weekEnd,
    required int totalScreenTime, // milliseconds
    required int averageDailyScreenTime,
    required int totalAppLaunches,
    required int averageDailyLaunches,
    required List<DailyUsageSummary> dailySummaries,
    required List<AppUsageStats> topAppsWeekly,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WeeklyUsageReport;

  const WeeklyUsageReport._();

  factory WeeklyUsageReport.fromJson(Map<String, dynamic> json) =>
      _$WeeklyUsageReportFromJson(json);

  Map<String, dynamic> toJson() => _$$WeeklyUsageReportImplToJson(this as _$WeeklyUsageReportImpl);

  // Firestore conversion methods
  factory WeeklyUsageReport.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WeeklyUsageReport(
      id: doc.id,
      childUserId: data['childUserId'] ?? '',
      weekStart: (data['weekStart'] as Timestamp).toDate(),
      weekEnd: (data['weekEnd'] as Timestamp).toDate(),
      totalScreenTime: data['totalScreenTime'] ?? 0,
      averageDailyScreenTime: data['averageDailyScreenTime'] ?? 0,
      totalAppLaunches: data['totalAppLaunches'] ?? 0,
      averageDailyLaunches: data['averageDailyLaunches'] ?? 0,
      dailySummaries: (data['dailySummaries'] as List<dynamic>?)
          ?.map((e) => DailyUsageSummary.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      topAppsWeekly: (data['topAppsWeekly'] as List<dynamic>?)
          ?.map((e) => AppUsageStats.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'childUserId': childUserId,
      'weekStart': Timestamp.fromDate(weekStart),
      'weekEnd': Timestamp.fromDate(weekEnd),
      'totalScreenTime': totalScreenTime,
      'averageDailyScreenTime': averageDailyScreenTime,
      'totalAppLaunches': totalAppLaunches,
      'averageDailyLaunches': averageDailyLaunches,
      'dailySummaries': dailySummaries.map((e) => e.toFirestore()).toList(),
      'topAppsWeekly': topAppsWeekly.map((e) => e.toFirestore()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
} 