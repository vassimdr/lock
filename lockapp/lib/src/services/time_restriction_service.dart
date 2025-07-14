import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lockapp/src/types/app_control_models.dart';
import 'package:lockapp/src/utils/error_handler.dart';

class TimeRestrictionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Remove test mode and mock data for real testing
dynamic get _testMode => false;

  /// Check if time restrictions are enabled
  Future<bool> hasTimeRestrictions() async {
    try {
      final restrictions = await getActiveTimeRestrictions();
      return restrictions.isNotEmpty;
    } catch (e) {
      print('Error checking time restrictions: $e');
      return false;
    }
  }

  /// Get all active time restrictions for a child
  Future<List<TimeRestriction>> getActiveTimeRestrictions({
    String? childUserId,
  }) async {
    try {
      // Check if collection exists first
      final collectionRef = _firestore.collection('time_restrictions');
      final snapshot = await collectionRef.limit(1).get();
      
      // If collection is empty or doesn't exist, return empty list
      if (snapshot.docs.isEmpty) {
        print('Time restrictions collection is empty or doesn\'t exist');
        return [];
      }

      Query query = collectionRef.where('isEnabled', isEqualTo: true);

      if (childUserId != null) {
        query = query.where('childUserId', isEqualTo: childUserId);
      }

      final resultSnapshot = await query.get();
      return resultSnapshot.docs
          .map((doc) => TimeRestriction.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting active time restrictions: $e');
      // Return empty list instead of throwing exception
      return [];
    }
  }

  /// Create or update a time restriction
  Future<TimeRestriction> createOrUpdateTimeRestriction({
    required String parentUserId,
    required String childUserId,
    required String packageName,
    required String appName,
    required int dailyTimeLimit, // in minutes
    required List<int> allowedDays, // 0-6 (Sunday-Saturday)
    required String startTime, // HH:mm format
    required String endTime, // HH:mm format
    bool isEnabled = true,
  }) async {
    try {
      final restriction = TimeRestriction(
        id: '${childUserId}_${packageName}_restriction',
        parentUserId: parentUserId,
        childUserId: childUserId,
        packageName: packageName,
        appName: appName,
        appIcon: '', // Empty for now - will be filled from installed apps
        isEnabled: isEnabled,
        dailyTimeLimit: dailyTimeLimit,
        allowedDays: allowedDays,
        startTime: startTime,
        endTime: endTime,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('time_restrictions')
          .doc(restriction.id)
          .set(restriction.toFirestore(), SetOptions(merge: true));

      return restriction;
    } catch (e) {
      print('Error creating/updating time restriction: $e');
      throw Exception('Failed to create/update time restriction: $e');
    }
  }

  /// Get time restrictions for a specific app
  Future<List<TimeRestriction>> getAppTimeRestrictions({
    required String childUserId,
    required String packageName,
  }) async {
    try {
      // Remove mock data usage
      final snapshot = await _firestore
          .collection('time_restrictions')
          .where('childUserId', isEqualTo: childUserId)
          .where('packageName', isEqualTo: packageName)
          .get();

      return snapshot.docs
          .map((doc) => TimeRestriction.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting app time restrictions: $e');
      throw Exception('Failed to get app time restrictions: $e');
    }
  }

  /// Check if an app is currently restricted
  Future<bool> isAppCurrentlyRestricted({
    required String childUserId,
    required String packageName,
  }) async {
    try {
      final restrictions = await getAppTimeRestrictions(
        childUserId: childUserId,
        packageName: packageName,
      );

      final now = DateTime.now();
      // Convert DateTime.weekday (1-7, Monday=1) to our format (0-6, Sunday=0)
      int currentDay;
      if (now.weekday == 7) {
        currentDay = 0; // Sunday
      } else {
        currentDay = now.weekday; // Monday=1, Tuesday=2, etc.
      }
      final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      for (final restriction in restrictions) {
        if (!restriction.isEnabled) continue;

        // Check if current day is allowed
        if (!restriction.allowedDays.contains(currentDay)) {
          return true; // Restricted because today is not allowed
        }

        // Check if current time is within allowed time range
        if (!_isTimeInRange(currentTime, restriction.startTime, restriction.endTime)) {
          return true; // Restricted because current time is outside allowed range
        }

        // Check daily time limit (this would require usage tracking)
        // For now, we'll assume it's not exceeded
      }

      return false;
    } catch (e) {
      print('Error checking if app is restricted: $e');
      return false;
    }
  }

  /// Delete a time restriction
  Future<void> deleteTimeRestriction(String restrictionId) async {
    try {
      if (!_testMode) {
        await _firestore
            .collection('time_restrictions')
            .doc(restrictionId)
            .delete();
      }
    } catch (e) {
      print('Error deleting time restriction: $e');
      throw Exception('Failed to delete time restriction: $e');
    }
  }

  /// Toggle time restriction enabled/disabled
  Future<void> toggleTimeRestriction(String restrictionId, bool isEnabled) async {
    try {
      if (!_testMode) {
        await _firestore
            .collection('time_restrictions')
            .doc(restrictionId)
            .update({
          'isEnabled': isEnabled,
          'updatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Error toggling time restriction: $e');
      throw Exception('Failed to toggle time restriction: $e');
    }
  }

  /// Get time restriction summary for a child
  Future<Map<String, dynamic>> getTimeRestrictionSummary({
    required String childUserId,
  }) async {
    try {
      final restrictions = await getActiveTimeRestrictions(childUserId: childUserId);
      
      final totalRestrictions = restrictions.length;
      final activeRestrictions = restrictions.where((r) => r.isEnabled).length;
      final restrictedApps = restrictions.map((r) => r.appName).toSet().length;

      return {
        'totalRestrictions': totalRestrictions,
        'activeRestrictions': activeRestrictions,
        'restrictedApps': restrictedApps,
        'restrictions': restrictions,
      };
    } catch (e) {
      print('Error getting time restriction summary: $e');
      throw Exception('Failed to get time restriction summary: $e');
    }
  }

  /// Check if current time is within allowed range
  bool _isTimeInRange(String currentTime, String startTime, String endTime) {
    final current = _parseTime(currentTime);
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);

    if (start <= end) {
      // Same day range (e.g., 09:00 - 17:00)
      return current >= start && current <= end;
    } else {
      // Overnight range (e.g., 22:00 - 06:00)
      return current >= start || current <= end;
    }
  }

  /// Parse time string to minutes since midnight
  int _parseTime(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }


} 