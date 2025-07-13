import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../types/pairing_request.dart';
import '../types/user_model.dart';
import '../types/device_model.dart';
import '../types/enums/user_role.dart';
import '../api/firestore_service.dart';

class QrPairingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  /// Generate QR code for parent device
  Future<PairingRequest> generatePairingRequest({
    required String parentName,
    required String parentDeviceId,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    // Generate unique QR code
    final qrCode = _generateQrCode();
    
    // Create pairing request
    final pairingRequest = PairingRequest(
      id: '', // Will be set by Firestore
      parentUserId: currentUser.uid,
      parentDeviceId: parentDeviceId,
      parentName: parentName,
      qrCode: qrCode,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)), // 24 hour expiry
    );

    // Save to Firestore
    final docRef = await _firestore
        .collection('pairing_requests')
        .add(pairingRequest.toFirestore());

    return pairingRequest.copyWith(id: docRef.id);
  }

  /// Scan QR code and create child account
  Future<UserModel> acceptPairingRequest({
    required String qrCode,
    required String childName,
    required String childDeviceId,
  }) async {
    // Find pairing request by QR code
    final querySnapshot = await _firestore
        .collection('pairing_requests')
        .where('qrCode', isEqualTo: qrCode)
        .where('isUsed', isEqualTo: false)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('QR kod geçersiz veya süresi dolmuş');
    }

    final pairingDoc = querySnapshot.docs.first;
    final pairingRequest = PairingRequest.fromFirestore(pairingDoc);

    // Create child user account (no email/password required)
    final childUser = UserModel(
      id: _generateUserId(),
      email: '', // No email for child accounts
      name: childName,
      role: UserRole.child,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
      parentUserId: pairingRequest.parentUserId,
    );

    // Save child user to Firestore
    await _firestore
        .collection('users')
        .doc(childUser.id)
        .set(childUser.toJson());

    // Create child device
    final childDevice = DeviceModel(
      id: _generateDeviceId(),
      userId: childUser.id,
      deviceName: 'Child Device',
      deviceId: childDeviceId,
      deviceType: DeviceType.childDevice,
      status: DeviceStatus.active,
      lastSeen: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save child device to Firestore
    await _firestore
        .collection('devices')
        .doc(childDevice.id)
        .set(childDevice.toJson());

    // Update pairing request as used
    await _firestore
        .collection('pairing_requests')
        .doc(pairingRequest.id)
        .update({
      'isUsed': true,
      'childUserId': childUser.id,
      'childDeviceId': childDevice.id,
      'childName': childName,
      'acceptedAt': Timestamp.now(),
    });

    // Create device pairing (implement this manually for now)
    await _firestore.collection('device_pairings').add({
      'parent_device_id': pairingRequest.parentDeviceId,
      'child_device_id': childDevice.id,
      'parent_user_id': pairingRequest.parentUserId,
      'child_user_id': childUser.id,
      'status': 'accepted',
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    });

    return childUser;
  }

  /// Get active pairing requests for current user
  Future<List<PairingRequest>> getActivePairingRequests() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final querySnapshot = await _firestore
        .collection('pairing_requests')
        .where('parentUserId', isEqualTo: currentUser.uid)
        .where('isUsed', isEqualTo: false)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => PairingRequest.fromFirestore(doc))
        .toList();
  }

  /// Delete pairing request
  Future<void> deletePairingRequest(String requestId) async {
    await _firestore
        .collection('pairing_requests')
        .doc(requestId)
        .delete();
  }

  /// Generate unique QR code
  String _generateQrCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// Generate unique user ID
  String _generateUserId() {
    return 'child_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
  }

  /// Generate unique device ID
  String _generateDeviceId() {
    return 'device_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
  }

  /// Clean up expired pairing requests
  Future<void> cleanupExpiredRequests() async {
    final querySnapshot = await _firestore
        .collection('pairing_requests')
        .where('expiresAt', isLessThan: Timestamp.now())
        .get();

    final batch = _firestore.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
} 