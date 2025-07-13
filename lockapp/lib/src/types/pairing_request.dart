import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'pairing_request.freezed.dart';
part 'pairing_request.g.dart';

@freezed
class PairingRequest with _$PairingRequest {
  const factory PairingRequest({
    required String id,
    required String parentUserId,
    required String parentDeviceId,
    required String parentName,
    required String qrCode,
    required DateTime createdAt,
    required DateTime expiresAt,
    @Default(false) bool isUsed,
    String? childUserId,
    String? childDeviceId,
    String? childName,
    DateTime? acceptedAt,
  }) = _PairingRequest;

  const PairingRequest._();

  factory PairingRequest.fromJson(Map<String, dynamic> json) =>
      _$PairingRequestFromJson(json);

  // Firestore conversion methods
  factory PairingRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PairingRequest.fromJson({
      'id': doc.id,
      ...data,
      'createdAt': (data['createdAt'] as Timestamp).toDate().toIso8601String(),
      'expiresAt': (data['expiresAt'] as Timestamp).toDate().toIso8601String(),
      'acceptedAt': data['acceptedAt'] != null
          ? (data['acceptedAt'] as Timestamp).toDate().toIso8601String()
          : null,
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    return {
      ...json,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
    };
  }
}

final PairingRequest emptyPairingRequest = PairingRequest(
  id: '',
  parentUserId: '',
  parentDeviceId: '',
  parentName: '',
  qrCode: '',
  createdAt: DateTime.now(),
  expiresAt: DateTime.now(),
); 