import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lockapp/src/types/user_model.dart';
import 'package:lockapp/src/types/device_model.dart';
import 'package:lockapp/src/types/enums/user_role.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections
  static const String _usersCollection = 'users';
  static const String _devicesCollection = 'devices';
  static const String _devicePairingsCollection = 'device_pairings';
  static const String _appListCollection = 'app_list';
  static const String _lockCommandsCollection = 'lock_commands';
  static const String _usageStatsCollection = 'usage_stats';

  /// Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // ===== USER OPERATIONS =====

  /// Create user profile
  static Future<void> createUser(UserModel user) async {
    await _firestore
        .collection(_usersCollection)
        .doc(user.id)
        .set(user.toJson());
  }

  /// Get user by ID
  static Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      data['id'] = doc.id;
      return UserModel.fromJson(data);
    }
    return null;
  }

  /// Update user profile
  static Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    updates['updated_at'] = FieldValue.serverTimestamp();
    await _firestore
        .collection(_usersCollection)
        .doc(userId)
        .update(updates);
  }

  /// Get users by role
  static Future<List<UserModel>> getUsersByRole(UserRole role) async {
    final query = await _firestore
        .collection(_usersCollection)
        .where('role', isEqualTo: role.value)
        .where('is_active', isEqualTo: true)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return UserModel.fromJson(data);
    }).toList();
  }

  // ===== DEVICE OPERATIONS =====

  /// Create device
  static Future<String> createDevice(DeviceModel device) async {
    final docRef = await _firestore
        .collection(_devicesCollection)
        .add(device.toFirestore());
    return docRef.id;
  }

  /// Get device by ID
  static Future<DeviceModel?> getDevice(String deviceId) async {
    final doc = await _firestore
        .collection(_devicesCollection)
        .doc(deviceId)
        .get();

    if (doc.exists) {
      return DeviceModel.fromFirestore(doc);
    }
    return null;
  }

  /// Get devices by user ID
  static Future<List<DeviceModel>> getUserDevices(String userId) async {
    final query = await _firestore
        .collection(_devicesCollection)
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .get();

    return query.docs.map((doc) => DeviceModel.fromFirestore(doc)).toList();
  }

  /// Update device
  static Future<void> updateDevice(String deviceId, Map<String, dynamic> updates) async {
    updates['updated_at'] = FieldValue.serverTimestamp();
    await _firestore
        .collection(_devicesCollection)
        .doc(deviceId)
        .update(updates);
  }

  /// Update device online status
  static Future<void> updateDeviceOnlineStatus(String deviceId, bool isOnline) async {
    await updateDevice(deviceId, {
      'is_online': isOnline,
      'last_seen': FieldValue.serverTimestamp(),
    });
  }

  /// Delete device
  static Future<void> deleteDevice(String deviceId) async {
    await _firestore
        .collection(_devicesCollection)
        .doc(deviceId)
        .delete();
  }

  /// Get device by device_id (unique identifier)
  static Future<DeviceModel?> getDeviceByDeviceId(String deviceId) async {
    final query = await _firestore
        .collection(_devicesCollection)
        .where('device_id', isEqualTo: deviceId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return DeviceModel.fromFirestore(query.docs.first);
    }
    return null;
  }

  // ===== DEVICE PAIRING OPERATIONS =====

  /// Create device pairing
  static Future<String> createDevicePairing({
    required String parentDeviceId,
    required String childDeviceId,
    required String parentUserId,
    required String childUserId,
  }) async {
    final docRef = await _firestore
        .collection(_devicePairingsCollection)
        .add({
      'parent_device_id': parentDeviceId,
      'child_device_id': childDeviceId,
      'parent_user_id': parentUserId,
      'child_user_id': childUserId,
      'status': 'pending',
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  /// Get device pairings for user
  static Future<List<Map<String, dynamic>>> getDevicePairings(String userId) async {
    final query = await _firestore
        .collection(_devicePairingsCollection)
        .where('parent_user_id', isEqualTo: userId)
        .get();

    final query2 = await _firestore
        .collection(_devicePairingsCollection)
        .where('child_user_id', isEqualTo: userId)
        .get();

    final allDocs = [...query.docs, ...query2.docs];
    
    return allDocs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  /// Update pairing status
  static Future<void> updatePairingStatus(String pairingId, String status) async {
    await _firestore
        .collection(_devicePairingsCollection)
        .doc(pairingId)
        .update({
      'status': status,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // ===== APP LIST OPERATIONS =====

  /// Add app to device
  static Future<void> addAppToDevice({
    required String deviceId,
    required String packageName,
    required String appName,
    String? version,
    String? iconUrl,
    String? category,
    bool isSystemApp = false,
  }) async {
    await _firestore
        .collection(_appListCollection)
        .add({
      'device_id': deviceId,
      'package_name': packageName,
      'app_name': appName,
      'version': version,
      'icon_url': iconUrl,
      'category': category,
      'is_system_app': isSystemApp,
      'is_locked': false,
      'lock_status': 'unlocked',
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  /// Get apps for device
  static Future<List<Map<String, dynamic>>> getDeviceApps(String deviceId) async {
    final query = await _firestore
        .collection(_appListCollection)
        .where('device_id', isEqualTo: deviceId)
        .orderBy('app_name')
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  /// Update app lock status
  static Future<void> updateAppLockStatus({
    required String deviceId,
    required String packageName,
    required bool isLocked,
  }) async {
    final query = await _firestore
        .collection(_appListCollection)
        .where('device_id', isEqualTo: deviceId)
        .where('package_name', isEqualTo: packageName)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.update({
        'is_locked': isLocked,
        'lock_status': isLocked ? 'locked' : 'unlocked',
        'updated_at': FieldValue.serverTimestamp(),
      });
    }
  }

  // ===== LOCK COMMANDS OPERATIONS =====

  /// Send lock command
  static Future<String> sendLockCommand({
    required String parentDeviceId,
    required String childDeviceId,
    required String appPackageName,
    required String commandType, // 'lock' or 'unlock'
  }) async {
    final docRef = await _firestore
        .collection(_lockCommandsCollection)
        .add({
      'parent_device_id': parentDeviceId,
      'child_device_id': childDeviceId,
      'app_package_name': appPackageName,
      'command_type': commandType,
      'status': 'pending',
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  /// Get pending lock commands for device
  static Future<List<Map<String, dynamic>>> getPendingLockCommands(String deviceId) async {
    final query = await _firestore
        .collection(_lockCommandsCollection)
        .where('child_device_id', isEqualTo: deviceId)
        .where('status', isEqualTo: 'pending')
        .orderBy('created_at', descending: true)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  /// Update lock command status
  static Future<void> updateLockCommandStatus(String commandId, String status) async {
    await _firestore
        .collection(_lockCommandsCollection)
        .doc(commandId)
        .update({
      'status': status,
      'executed_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // ===== USAGE STATS OPERATIONS =====

  /// Add usage stat
  static Future<void> addUsageStat({
    required String deviceId,
    required String userId,
    required String appPackageName,
    required String appName,
    required DateTime usageDate,
    required int totalTimeMinutes,
    required int openCount,
  }) async {
    final docId = '${deviceId}_${appPackageName}_${usageDate.toString().substring(0, 10)}';
    
    await _firestore
        .collection(_usageStatsCollection)
        .doc(docId)
        .set({
      'device_id': deviceId,
      'user_id': userId,
      'app_package_name': appPackageName,
      'app_name': appName,
      'usage_date': Timestamp.fromDate(usageDate),
      'total_time_minutes': totalTimeMinutes,
      'open_count': openCount,
      'last_used': FieldValue.serverTimestamp(),
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Get usage stats for device
  static Future<List<Map<String, dynamic>>> getUsageStats({
    required String deviceId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Query query = _firestore
        .collection(_usageStatsCollection)
        .where('device_id', isEqualTo: deviceId);

    if (startDate != null) {
      query = query.where('usage_date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }
    if (endDate != null) {
      query = query.where('usage_date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    final result = await query.orderBy('usage_date', descending: true).get();

    return result.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // ===== REAL-TIME LISTENERS =====

  /// Listen to user changes
  static Stream<UserModel?> listenToUser(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return UserModel.fromJson(data);
      }
      return null;
    });
  }

  /// Listen to device changes
  static Stream<List<DeviceModel>> listenToUserDevices(String userId) {
    return _firestore
        .collection(_devicesCollection)
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DeviceModel.fromFirestore(doc))
            .toList());
  }

  /// Listen to device apps
  static Stream<List<Map<String, dynamic>>> listenToDeviceApps(String deviceId) {
    return _firestore
        .collection(_appListCollection)
        .where('device_id', isEqualTo: deviceId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  /// Listen to pending lock commands
  static Stream<List<Map<String, dynamic>>> listenToPendingLockCommands(String deviceId) {
    return _firestore
        .collection(_lockCommandsCollection)
        .where('child_device_id', isEqualTo: deviceId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }
} 