import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lockapp/src/types/enums/user_role.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String name;
  @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)
  final UserRole role;
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final Map<String, dynamic>? metadata;

  static UserRole _roleFromJson(String role) => UserRole.fromString(role);
  static String _roleToJson(UserRole role) => role.value;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.metadata,
  });

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Firestore document ID is separate
    
    // Convert DateTime to Timestamp for Firestore
    json['created_at'] = Timestamp.fromDate(createdAt);
    json['updated_at'] = Timestamp.fromDate(updatedAt);
    
    return json;
  }

  /// Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    
    // Convert Timestamp to DateTime
    if (data['created_at'] is Timestamp) {
      data['created_at'] = (data['created_at'] as Timestamp).toDate().toIso8601String();
    }
    if (data['updated_at'] is Timestamp) {
      data['updated_at'] = (data['updated_at'] as Timestamp).toDate().toIso8601String();
    }
    
    return UserModel.fromJson(data);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.role == role &&
        other.profileImageUrl == profileImageUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        role.hashCode ^
        profileImageUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isActive.hashCode;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, role: $role, profileImageUrl: $profileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, metadata: $metadata)';
  }

  // Helper methods
  bool get isParent => role.isParent;
  bool get isChild => role.isChild;
  
  String get displayName => name.isNotEmpty ? name : email.split('@').first;
} 