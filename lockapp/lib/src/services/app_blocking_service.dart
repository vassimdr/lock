import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../types/app_control_models.dart';

class AppBlockingService {
  static const MethodChannel _channel = MethodChannel('lockapp/app_blocking');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Remove test mode for real testing
  bool _testMode = false;

  // Check if app has device admin permissions
  Future<bool> hasDeviceAdminPermission() async {
    try {
      final bool hasPermission = await _channel.invokeMethod('hasDeviceAdminPermission');
      return hasPermission;
    } catch (e) {
      print('Error checking device admin permission: $e');
      return false;
    }
  }

  // Request device admin permissions
  Future<bool> requestDeviceAdminPermission() async {
    try {
      final bool granted = await _channel.invokeMethod('requestDeviceAdminPermission');
      return granted;
    } catch (e) {
      print('Error requesting device admin permission: $e');
      return false;
    }
  }

  // Block an app
  Future<bool> blockApp(String packageName) async {
    try {
      final bool success = await _channel.invokeMethod('blockApp', {
        'packageName': packageName,
      });
      return success;
    } catch (e) {
      print('Error blocking app: $e');
      return false;
    }
  }

  // Unblock an app
  Future<bool> unblockApp(String packageName) async {
    try {
      final bool success = await _channel.invokeMethod('unblockApp', {
        'packageName': packageName,
      });
      return success;
    } catch (e) {
      print('Error unblocking app: $e');
      return false;
    }
  }

  // Get list of installed apps
  Future<List<Map<String, dynamic>>> getInstalledApps() async {
    try {
      final List<dynamic> apps = await _channel.invokeMethod('getInstalledApps');
      return apps.map((app) {
        if (app is Map<String, dynamic>) {
          return app;
        } else if (app is Map) {
          // Safe conversion with validation
          try {
            return Map<String, dynamic>.from(app);
          } catch (e) {
            print('Warning: Failed to convert app data to Map<String, dynamic>: $app, error: $e');
            return <String, dynamic>{'packageName': 'unknown', 'appName': 'Unknown App'};
          }
        } else {
          print('Warning: App data is not a Map: $app');
          return <String, dynamic>{'packageName': 'unknown', 'appName': 'Unknown App'};
        }
      }).toList();
    } catch (e) {
      print('Error getting installed apps: $e');
      return [];
    }
  }

  // Create or update app block rule
  Future<AppBlockRule> createBlockRule({
    required String parentUserId,
    required String childUserId,
    required String packageName,
    required String appName,
    required String appIcon,
    required bool isBlocked,
    String? reason,
    DateTime? blockedUntil,
  }) async {
    final rule = AppBlockRule(
      id: '', // Will be set by Firestore
      parentUserId: parentUserId,
      childUserId: childUserId,
      packageName: packageName,
      appName: appName,
      appIcon: appIcon,
      isBlocked: isBlocked,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      reason: reason,
      blockedUntil: blockedUntil,
    );

    try {
      final docRef = await _firestore
          .collection('app_block_rules')
          .add(rule.toFirestore());
      
      final createdRule = rule.copyWith(id: docRef.id);
      
      // Apply the block/unblock on device
      if (isBlocked) {
        await blockApp(packageName);
      } else {
        await unblockApp(packageName);
      }
      
      return createdRule;
    } catch (e) {
      print('Error creating block rule: $e');
      throw Exception('Failed to create block rule: $e');
    }
  }

  // Get block rules for a child
  Future<List<AppBlockRule>> getBlockRules({
    required String childUserId,
  }) async {
    try {
      // Check if collection exists first
      final collectionRef = _firestore.collection('app_block_rules');
      final snapshot = await collectionRef.limit(1).get();
      
      // If collection is empty or doesn't exist, return empty list
      if (snapshot.docs.isEmpty) {
        print('App block rules collection is empty or doesn\'t exist');
        return [];
      }

      final QuerySnapshot querySnapshot = await collectionRef
          .where('childUserId', isEqualTo: childUserId)
          .get();

      return querySnapshot.docs
          .map((doc) => AppBlockRule.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting block rules: $e');
      // Return empty list instead of throwing exception
      return [];
    }
  }

  // Update block rule
  Future<AppBlockRule> updateBlockRule({
    required String ruleId,
    required bool isBlocked,
    String? reason,
    DateTime? blockedUntil,
  }) async {
    try {
      final docRef = _firestore.collection('app_block_rules').doc(ruleId);
      
      await docRef.update({
        'isBlocked': isBlocked,
        'reason': reason,
        'blockedUntil': blockedUntil != null 
            ? Timestamp.fromDate(blockedUntil) 
            : null,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      final updatedDoc = await docRef.get();
      final updatedRule = AppBlockRule.fromFirestore(updatedDoc);
      
      // Apply the block/unblock on device
      if (isBlocked) {
        await blockApp(updatedRule.packageName);
      } else {
        await unblockApp(updatedRule.packageName);
      }
      
      return updatedRule;
    } catch (e) {
      print('Error updating block rule: $e');
      throw Exception('Failed to update block rule: $e');
    }
  }

  // Delete block rule
  Future<void> deleteBlockRule(String ruleId) async {
    try {
      // Get the rule first to unblock the app
      final docRef = _firestore.collection('app_block_rules').doc(ruleId);
      final doc = await docRef.get();
      
      if (doc.exists) {
        final rule = AppBlockRule.fromFirestore(doc);
        await unblockApp(rule.packageName);
      }
      
      await docRef.delete();
    } catch (e) {
      print('Error deleting block rule: $e');
      throw Exception('Failed to delete block rule: $e');
    }
  }

  // Log block attempt
  Future<void> logBlockAttempt({
    required String childUserId,
    required String packageName,
    required String appName,
    required String blockReason,
    required bool wasBlocked,
  }) async {
    final log = BlockAttemptLog(
      id: '', // Will be set by Firestore
      childUserId: childUserId,
      packageName: packageName,
      appName: appName,
      attemptTime: DateTime.now(),
      blockReason: blockReason,
      wasBlocked: wasBlocked,
      createdAt: DateTime.now(),
    );

    try {
      await _firestore
          .collection('block_attempt_logs')
          .add(log.toFirestore());
    } catch (e) {
      print('Error logging block attempt: $e');
    }
  }

  // Get block attempt logs
  Future<List<BlockAttemptLog>> getBlockAttemptLogs({
    required String childUserId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Check if collection exists first
      final collectionRef = _firestore.collection('block_attempt_logs');
      final snapshot = await collectionRef.limit(1).get();
      
      // If collection is empty or doesn't exist, return empty list
      if (snapshot.docs.isEmpty) {
        print('Block attempt logs collection is empty or doesn\'t exist');
        return [];
      }

      Query query = collectionRef.where('childUserId', isEqualTo: childUserId);

      if (startDate != null) {
        query = query.where('attemptTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }
      
      if (endDate != null) {
        query = query.where('attemptTime', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      final QuerySnapshot querySnapshot = await query
          .orderBy('attemptTime', descending: true)
          .limit(100)
          .get();

      return querySnapshot.docs
          .map((doc) => BlockAttemptLog.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting block attempt logs: $e');
      // Return empty list instead of throwing exception
      return [];
    }
  }

  // Generate app control summary
  Future<AppControlSummary> generateAppControlSummary({
    required String childUserId,
    required DateTime date,
  }) async {
    try {
      final blockRules = await getBlockRules(childUserId: childUserId);
      final blockedApps = blockRules.where((rule) => rule.isCurrentlyBlocked).toList();
      
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final blockAttempts = await getBlockAttemptLogs(
        childUserId: childUserId,
        startDate: startOfDay,
        endDate: endOfDay,
      );

      // Count most blocked apps
      final Map<String, int> appBlockCounts = {};
      for (final attempt in blockAttempts) {
        appBlockCounts[attempt.packageName] = (appBlockCounts[attempt.packageName] ?? 0) + 1;
      }
      
      final mostBlockedApps = appBlockCounts.entries
          .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

      final summary = AppControlSummary(
        id: '${childUserId}_${date.toIso8601String().split('T')[0]}',
        childUserId: childUserId,
        date: date,
        totalBlockedApps: blockedApps.length,
        totalTimeRestrictedApps: 0, // Will be implemented with time restrictions
        totalBlockAttempts: blockAttempts.length,
        mostBlockedApps: mostBlockedApps.take(5).map((e) => e.key).toList(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('app_control_summaries')
          .doc(summary.id)
          .set(summary.toFirestore(), SetOptions(merge: true));

      return summary;
    } catch (e) {
      print('Error generating app control summary: $e');
      throw Exception('Failed to generate app control summary: $e');
    }
  }

  // Sync block rules to device
  Future<void> syncBlockRulesToDevice({
    required String childUserId,
  }) async {
    try {
      final blockRules = await getBlockRules(childUserId: childUserId);
      
      for (final rule in blockRules) {
        if (rule.isCurrentlyBlocked) {
          await blockApp(rule.packageName);
        } else {
          await unblockApp(rule.packageName);
        }
      }
    } catch (e) {
      print('Error syncing block rules to device: $e');
      throw Exception('Failed to sync block rules to device: $e');
    }
  }


}

// Extension to add copyWith method to AppBlockRule
extension AppBlockRuleExtension on AppBlockRule {
  AppBlockRule copyWith({
    String? id,
    String? parentUserId,
    String? childUserId,
    String? packageName,
    String? appName,
    String? appIcon,
    bool? isBlocked,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? reason,
    DateTime? blockedUntil,
  }) {
    return AppBlockRule(
      id: id ?? this.id,
      parentUserId: parentUserId ?? this.parentUserId,
      childUserId: childUserId ?? this.childUserId,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      appIcon: appIcon ?? this.appIcon,
      isBlocked: isBlocked ?? this.isBlocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reason: reason ?? this.reason,
      blockedUntil: blockedUntil ?? this.blockedUntil,
    );
  }
} 