import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../types/app_usage_stats.dart';

class UsageStatsService {
  static const MethodChannel _channel = MethodChannel('lockapp/usage_stats');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // TEST MODE - Development only
  static const bool _testMode = true;

  /// Check if usage access permission is granted
  Future<bool> hasUsageStatsPermission() async {
    try {
      final bool hasPermission = await _channel.invokeMethod('hasUsageStatsPermission');
      return hasPermission;
    } on PlatformException catch (e) {
      print('Error checking usage stats permission: ${e.message}');
      return false;
    }
  }

  /// Request usage access permission
  Future<void> requestUsageStatsPermission() async {
    try {
      await _channel.invokeMethod('requestUsageStatsPermission');
    } on PlatformException catch (e) {
      print('Error requesting usage stats permission: ${e.message}');
      throw Exception('Usage stats permission request failed: ${e.message}');
    }
  }

  /// Get usage stats for a specific date
  Future<List<AppUsageStats>> getUsageStatsForDate(DateTime date) async {
    try {
      final String dateString = date.toIso8601String().split('T')[0];
      final List<dynamic> result = await _channel.invokeMethod('getUsageStatsForDate', {
        'date': dateString,
      });

      final List<AppUsageStats> usageStats = [];
      final String currentUserId = _auth.currentUser?.uid ?? '';

      for (final dynamic item in result) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(item);
        
        final appUsageStats = AppUsageStats(
          id: '${currentUserId}_${data['packageName']}_${dateString}',
          childUserId: currentUserId,
          packageName: data['packageName'] ?? '',
          appName: data['appName'] ?? '',
          appIcon: data['appIcon'] ?? '', // Base64 encoded icon
          date: date,
          totalTimeInForeground: data['totalTimeInForeground'] ?? 0,
          launchCount: data['launchCount'] ?? 0,
          firstTimeStamp: DateTime.fromMillisecondsSinceEpoch(data['firstTimeStamp'] ?? 0),
          lastTimeStamp: DateTime.fromMillisecondsSinceEpoch(data['lastTimeStamp'] ?? 0),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        usageStats.add(appUsageStats);
      }

      return usageStats;
    } on PlatformException catch (e) {
      print('Error getting usage stats: ${e.message}');
      throw Exception('Failed to get usage stats: ${e.message}');
    }
  }

  /// Get usage stats for a date range
  Future<List<AppUsageStats>> getUsageStatsForDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final String startDateString = startDate.toIso8601String().split('T')[0];
      final String endDateString = endDate.toIso8601String().split('T')[0];
      
      final List<dynamic> result = await _channel.invokeMethod('getUsageStatsForDateRange', {
        'startDate': startDateString,
        'endDate': endDateString,
      });

      final List<AppUsageStats> usageStats = [];
      final String currentUserId = _auth.currentUser?.uid ?? '';

      for (final dynamic item in result) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(item);
        
        final appUsageStats = AppUsageStats(
          id: '${currentUserId}_${data['packageName']}_${data['date']}',
          childUserId: currentUserId,
          packageName: data['packageName'] ?? '',
          appName: data['appName'] ?? '',
          appIcon: data['appIcon'] ?? '',
          date: DateTime.parse(data['date']),
          totalTimeInForeground: data['totalTimeInForeground'] ?? 0,
          launchCount: data['launchCount'] ?? 0,
          firstTimeStamp: DateTime.fromMillisecondsSinceEpoch(data['firstTimeStamp'] ?? 0),
          lastTimeStamp: DateTime.fromMillisecondsSinceEpoch(data['lastTimeStamp'] ?? 0),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        usageStats.add(appUsageStats);
      }

      return usageStats;
    } on PlatformException catch (e) {
      print('Error getting usage stats for date range: ${e.message}');
      throw Exception('Failed to get usage stats for date range: ${e.message}');
    }
  }

  /// Sync usage stats to Firestore
  Future<void> syncUsageStatsToFirestore(List<AppUsageStats> usageStats) async {
    try {
      final WriteBatch batch = _firestore.batch();

      for (final AppUsageStats stats in usageStats) {
        final DocumentReference docRef = _firestore
            .collection('usage_stats')
            .doc(stats.id);

        batch.set(docRef, stats.toFirestore(), SetOptions(merge: true));
      }

      await batch.commit();
      print('Successfully synced ${usageStats.length} usage stats to Firestore');
    } catch (e) {
      print('Error syncing usage stats to Firestore: $e');
      throw Exception('Failed to sync usage stats: $e');
    }
  }

  /// Get usage stats from Firestore
  Future<List<AppUsageStats>> getUsageStatsFromFirestore({
    required String childUserId,
    required DateTime date,
  }) async {
    try {
      // Check if collection exists first
      final collectionRef = _firestore.collection('usage_stats');
      final testSnapshot = await collectionRef.limit(1).get();
      
      // If collection is empty or doesn't exist, return empty list
      if (testSnapshot.docs.isEmpty) {
        print('Usage stats collection is empty or doesn\'t exist');
        return [];
      }

      // Simplified query without orderBy to avoid index requirement
      final QuerySnapshot querySnapshot = await collectionRef
          .where('childUserId', isEqualTo: childUserId)
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .get();

      // Sort in memory instead of Firestore
      final List<AppUsageStats> usageStats = querySnapshot.docs
          .map((doc) => AppUsageStats.fromFirestore(doc))
          .toList();
      
      // Sort by usage time descending
      usageStats.sort((a, b) => b.totalTimeInForeground.compareTo(a.totalTimeInForeground));
      
      return usageStats;
    } catch (e) {
      print('Error getting usage stats from Firestore: $e');
      throw Exception('Failed to get usage stats from Firestore: $e');
    }
  }

  /// Generate daily usage summary
  Future<DailyUsageSummary> generateDailyUsageSummary({
    required String childUserId,
    required DateTime date,
  }) async {
    try {
      final List<AppUsageStats> usageStats = await getUsageStatsFromFirestore(
        childUserId: childUserId,
        date: date,
      );

      if (usageStats.isEmpty) {
        return DailyUsageSummary(
          id: '${childUserId}_${date.toIso8601String().split('T')[0]}',
          childUserId: childUserId,
          date: date,
          totalScreenTime: 0,
          totalAppLaunches: 0,
          uniqueAppsUsed: 0,
          mostUsedApp: '',
          mostUsedAppTime: 0,
          topApps: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      // Calculate totals
      final int totalScreenTime = usageStats.fold(0, (sum, stat) => sum + stat.totalTimeInForeground);
      final int totalAppLaunches = usageStats.fold(0, (sum, stat) => sum + stat.launchCount);
      final int uniqueAppsUsed = usageStats.length;

      // Find most used app
      final AppUsageStats mostUsedAppStats = usageStats.first;
      final String mostUsedApp = mostUsedAppStats.appName;
      final int mostUsedAppTime = mostUsedAppStats.totalTimeInForeground;

      // Get top 10 apps
      final List<AppUsageStats> topApps = usageStats.take(10).toList();

      final DailyUsageSummary summary = DailyUsageSummary(
        id: '${childUserId}_${date.toIso8601String().split('T')[0]}',
        childUserId: childUserId,
        date: date,
        totalScreenTime: totalScreenTime,
        totalAppLaunches: totalAppLaunches,
        uniqueAppsUsed: uniqueAppsUsed,
        mostUsedApp: mostUsedApp,
        mostUsedAppTime: mostUsedAppTime,
        topApps: topApps,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('daily_usage_summaries')
          .doc(summary.id)
          .set(summary.toFirestore(), SetOptions(merge: true));

      return summary;
    } catch (e) {
      print('Error generating daily usage summary: $e');
      throw Exception('Failed to generate daily usage summary: $e');
    }
  }

  /// Generate weekly usage report
  Future<WeeklyUsageReport> generateWeeklyUsageReport({
    required String childUserId,
    required DateTime weekStart,
  }) async {
    try {
      final DateTime weekEnd = weekStart.add(const Duration(days: 6));
      final List<DailyUsageSummary> dailySummaries = [];

      // Get daily summaries for the week
      for (int i = 0; i < 7; i++) {
        final DateTime currentDate = weekStart.add(Duration(days: i));
        try {
          final DailyUsageSummary summary = await generateDailyUsageSummary(
            childUserId: childUserId,
            date: currentDate,
          );
          dailySummaries.add(summary);
        } catch (e) {
          print('Error getting daily summary for ${currentDate}: $e');
          // Create empty summary for failed days
          final emptySummary = DailyUsageSummary(
            id: '${childUserId}_${currentDate.toIso8601String().split('T')[0]}',
            childUserId: childUserId,
            date: currentDate,
            totalScreenTime: 0,
            totalAppLaunches: 0,
            uniqueAppsUsed: 0,
            mostUsedApp: '',
            mostUsedAppTime: 0,
            topApps: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          dailySummaries.add(emptySummary);
        }
      }

      // Calculate weekly totals
      final int totalScreenTime = dailySummaries.fold(0, (sum, summary) => sum + summary.totalScreenTime);
      final int averageDailyScreenTime = dailySummaries.isNotEmpty ? totalScreenTime ~/ dailySummaries.length : 0;
      final int totalAppLaunches = dailySummaries.fold(0, (sum, summary) => sum + summary.totalAppLaunches);
      final int averageDailyLaunches = dailySummaries.isNotEmpty ? totalAppLaunches ~/ dailySummaries.length : 0;

      // Get top apps for the week
      final Map<String, AppUsageStats> weeklyAppStats = {};
      for (final DailyUsageSummary summary in dailySummaries) {
        for (final AppUsageStats appStat in summary.topApps) {
          if (weeklyAppStats.containsKey(appStat.packageName)) {
            final existing = weeklyAppStats[appStat.packageName]!;
            // Create new instance instead of using copyWith
            weeklyAppStats[appStat.packageName] = AppUsageStats(
              id: existing.id,
              childUserId: existing.childUserId,
              packageName: existing.packageName,
              appName: existing.appName,
              appIcon: existing.appIcon,
              date: existing.date,
              totalTimeInForeground: existing.totalTimeInForeground + appStat.totalTimeInForeground,
              launchCount: existing.launchCount + appStat.launchCount,
              firstTimeStamp: existing.firstTimeStamp,
              lastTimeStamp: appStat.lastTimeStamp.isAfter(existing.lastTimeStamp) 
                  ? appStat.lastTimeStamp 
                  : existing.lastTimeStamp,
              createdAt: existing.createdAt,
              updatedAt: DateTime.now(),
            );
          } else {
            weeklyAppStats[appStat.packageName] = appStat;
          }
        }
      }

      final List<AppUsageStats> topAppsWeekly = weeklyAppStats.values.toList()
        ..sort((a, b) => b.totalTimeInForeground.compareTo(a.totalTimeInForeground));

      final WeeklyUsageReport report = WeeklyUsageReport(
        id: '${childUserId}_${weekStart.toIso8601String().split('T')[0]}',
        childUserId: childUserId,
        weekStart: weekStart,
        weekEnd: weekEnd,
        totalScreenTime: totalScreenTime,
        averageDailyScreenTime: averageDailyScreenTime,
        totalAppLaunches: totalAppLaunches,
        averageDailyLaunches: averageDailyLaunches,
        dailySummaries: dailySummaries,
        topAppsWeekly: topAppsWeekly.take(10).toList(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('weekly_usage_reports')
          .doc(report.id)
          .set(report.toFirestore(), SetOptions(merge: true));

      return report;
    } catch (e) {
      print('Error generating weekly usage report: $e');
      // Return empty report instead of throwing
      return WeeklyUsageReport(
        id: '${childUserId}_${weekStart.toIso8601String().split('T')[0]}_empty',
        childUserId: childUserId,
        weekStart: weekStart,
        weekEnd: weekStart.add(const Duration(days: 6)),
        totalScreenTime: 0,
        averageDailyScreenTime: 0,
        totalAppLaunches: 0,
        averageDailyLaunches: 0,
        dailySummaries: [],
        topAppsWeekly: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Auto-sync usage stats (should be called periodically)
  Future<void> autoSyncUsageStats() async {
    try {
      if (!await hasUsageStatsPermission()) {
        print('Usage stats permission not granted');
        return;
      }

      final DateTime today = DateTime.now();
      final DateTime yesterday = today.subtract(const Duration(days: 1));

      // Get usage stats for yesterday
      final List<AppUsageStats> usageStats = await getUsageStatsForDate(yesterday);
      
      if (usageStats.isNotEmpty) {
        await syncUsageStatsToFirestore(usageStats);
        
        // Generate daily summary
        final String currentUserId = _auth.currentUser?.uid ?? '';
        if (currentUserId.isNotEmpty) {
          await generateDailyUsageSummary(
            childUserId: currentUserId,
            date: yesterday,
          );
        }
      }
    } catch (e) {
      print('Error in auto-sync usage stats: $e');
    }
  }

  /// TEST MODE: Generate mock usage stats

} 