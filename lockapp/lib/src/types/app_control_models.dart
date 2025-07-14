import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'app_control_models.freezed.dart';
part 'app_control_models.g.dart';

// App Block Rule Model
@freezed
class AppBlockRule with _$AppBlockRule {
  const factory AppBlockRule({
    required String id,
    required String parentUserId,
    required String childUserId,
    required String packageName,
    required String appName,
    required String appIcon, // Base64 encoded icon
    required bool isBlocked,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? reason, // Optional reason for blocking
    DateTime? blockedUntil, // Optional end time for temporary blocks
  }) = _AppBlockRule;

  const AppBlockRule._();

  factory AppBlockRule.fromJson(Map<String, dynamic> json) =>
      _$AppBlockRuleFromJson(json);

  // Firestore conversion methods
  factory AppBlockRule.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppBlockRule(
      id: doc.id,
      parentUserId: data['parentUserId'] ?? '',
      childUserId: data['childUserId'] ?? '',
      packageName: data['packageName'] ?? '',
      appName: data['appName'] ?? '',
      appIcon: data['appIcon'] ?? '',
      isBlocked: data['isBlocked'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      reason: data['reason'],
      blockedUntil: data['blockedUntil'] != null 
          ? (data['blockedUntil'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'parentUserId': parentUserId,
      'childUserId': childUserId,
      'packageName': packageName,
      'appName': appName,
      'appIcon': appIcon,
      'isBlocked': isBlocked,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'reason': reason,
      'blockedUntil': blockedUntil != null 
          ? Timestamp.fromDate(blockedUntil!) 
          : null,
    };
  }

  // Helper methods
  bool get isTemporaryBlock => blockedUntil != null;
  
  bool get isCurrentlyBlocked {
    if (!isBlocked) return false;
    if (blockedUntil == null) return true;
    return DateTime.now().isBefore(blockedUntil!);
  }
  
  String get blockStatusText {
    if (!isBlocked) return 'Aktif';
    if (isTemporaryBlock) {
      if (isCurrentlyBlocked) {
        return 'Geçici olarak kilitli';
      } else {
        return 'Kilit süresi doldu';
      }
    }
    return 'Kalıcı olarak kilitli';
  }
}

// Time Restriction Model
@freezed
class TimeRestriction with _$TimeRestriction {
  const factory TimeRestriction({
    required String id,
    required String parentUserId,
    required String childUserId,
    required String packageName,
    required String appName,
    required String appIcon, // Base64 encoded icon
    required bool isEnabled,
    required int dailyTimeLimit, // in minutes
    required List<int> allowedDays, // 0-6 (Sunday-Saturday)
    required String startTime, // HH:mm format
    required String endTime, // HH:mm format
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TimeRestriction;

  const TimeRestriction._();

  factory TimeRestriction.fromJson(Map<String, dynamic> json) =>
      _$TimeRestrictionFromJson(json);

  // Firestore conversion methods
  factory TimeRestriction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TimeRestriction(
      id: doc.id,
      parentUserId: data['parentUserId'] ?? '',
      childUserId: data['childUserId'] ?? '',
      packageName: data['packageName'] ?? '',
      appName: data['appName'] ?? '',
      appIcon: data['appIcon'] ?? '',
      isEnabled: data['isEnabled'] ?? false,
      dailyTimeLimit: data['dailyTimeLimit'] ?? 0,
      allowedDays: List<int>.from(data['allowedDays'] ?? []),
      startTime: data['startTime'] ?? '00:00',
      endTime: data['endTime'] ?? '23:59',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'parentUserId': parentUserId,
      'childUserId': childUserId,
      'packageName': packageName,
      'appName': appName,
      'appIcon': appIcon,
      'isEnabled': isEnabled,
      'dailyTimeLimit': dailyTimeLimit,
      'allowedDays': allowedDays,
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Helper methods
  String get formattedDailyLimit {
    final hours = dailyTimeLimit ~/ 60;
    final minutes = dailyTimeLimit % 60;
    
    if (hours > 0) {
      return '${hours}s ${minutes}d';
    } else {
      return '${minutes}d';
    }
  }
  
  String get allowedDaysText {
    const dayNames = ['Pazar', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'];
    
    // Filter out invalid day values and ensure they're in 0-6 range
    final validDays = allowedDays
        .where((day) => day >= 0 && day <= 6)
        .toList();
    
    if (validDays.isEmpty) return 'Hiçbir gün';
    if (validDays.length == 7) return 'Her gün';
    if (validDays.length == 5 && !validDays.contains(0) && !validDays.contains(6)) {
      return 'Hafta içi';
    }
    if (validDays.length == 2 && validDays.contains(0) && validDays.contains(6)) {
      return 'Hafta sonu';
    }
    
    try {
      return validDays.map((day) => dayNames[day]).join(', ');
    } catch (e) {
      print('Error in allowedDaysText: $e, validDays: $validDays');
      return 'Geçersiz günler';
    }
  }
  
  bool get isActiveToday {
    if (!isEnabled) return false;
    
    // Convert DateTime.weekday (1-7, Monday=1) to our format (0-6, Sunday=0)
    // DateTime.weekday: Monday=1, Tuesday=2, ..., Sunday=7
    // Our format: Sunday=0, Monday=1, ..., Saturday=6
    int today;
    if (DateTime.now().weekday == 7) {
      today = 0; // Sunday
    } else {
      today = DateTime.now().weekday; // Monday=1, Tuesday=2, etc.
    }
    
    // Filter out invalid day values
    final validDays = allowedDays
        .where((day) => day >= 0 && day <= 6)
        .toList();
    
    return validDays.contains(today);
  }
  
  bool get isActiveNow {
    if (!isActiveToday) return false;
    
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    return currentTime.compareTo(startTime) >= 0 && currentTime.compareTo(endTime) <= 0;
  }
}

// App Control Summary Model
@freezed
class AppControlSummary with _$AppControlSummary {
  const factory AppControlSummary({
    required String id,
    required String childUserId,
    required DateTime date,
    required int totalBlockedApps,
    required int totalTimeRestrictedApps,
    required int totalBlockAttempts,
    required List<String> mostBlockedApps,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppControlSummary;

  const AppControlSummary._();

  factory AppControlSummary.fromJson(Map<String, dynamic> json) =>
      _$AppControlSummaryFromJson(json);

  // Firestore conversion methods
  factory AppControlSummary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppControlSummary(
      id: doc.id,
      childUserId: data['childUserId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      totalBlockedApps: data['totalBlockedApps'] ?? 0,
      totalTimeRestrictedApps: data['totalTimeRestrictedApps'] ?? 0,
      totalBlockAttempts: data['totalBlockAttempts'] ?? 0,
      mostBlockedApps: List<String>.from(data['mostBlockedApps'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'childUserId': childUserId,
      'date': Timestamp.fromDate(date),
      'totalBlockedApps': totalBlockedApps,
      'totalTimeRestrictedApps': totalTimeRestrictedApps,
      'totalBlockAttempts': totalBlockAttempts,
      'mostBlockedApps': mostBlockedApps,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

// Block Attempt Log Model
@freezed
class BlockAttemptLog with _$BlockAttemptLog {
  const factory BlockAttemptLog({
    required String id,
    required String childUserId,
    required String packageName,
    required String appName,
    required DateTime attemptTime,
    required String blockReason,
    required bool wasBlocked,
    required DateTime createdAt,
  }) = _BlockAttemptLog;

  const BlockAttemptLog._();

  factory BlockAttemptLog.fromJson(Map<String, dynamic> json) =>
      _$BlockAttemptLogFromJson(json);

  // Firestore conversion methods
  factory BlockAttemptLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BlockAttemptLog(
      id: doc.id,
      childUserId: data['childUserId'] ?? '',
      packageName: data['packageName'] ?? '',
      appName: data['appName'] ?? '',
      attemptTime: (data['attemptTime'] as Timestamp).toDate(),
      blockReason: data['blockReason'] ?? '',
      wasBlocked: data['wasBlocked'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'childUserId': childUserId,
      'packageName': packageName,
      'appName': appName,
      'attemptTime': Timestamp.fromDate(attemptTime),
      'blockReason': blockReason,
      'wasBlocked': wasBlocked,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Helper methods
  String get formattedAttemptTime {
    final now = DateTime.now();
    final difference = now.difference(attemptTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Şimdi';
    }
  }
} 