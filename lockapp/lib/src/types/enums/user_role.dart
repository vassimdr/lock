enum UserRole {
  parent('parent'),
  child('child');

  const UserRole(this.value);
  
  final String value;

  /// Convert from string to enum
  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'parent':
        return UserRole.parent;
      case 'child':
        return UserRole.child;
      default:
        throw ArgumentError('Invalid user role: $value');
    }
  }

  /// Convert to string
  @override
  String toString() => value;

  /// Check if user is parent
  bool get isParent => this == UserRole.parent;

  /// Check if user is child
  bool get isChild => this == UserRole.child;

  /// Get display name in Turkish
  String get displayName {
    switch (this) {
      case UserRole.parent:
        return 'Ebeveyn';
      case UserRole.child:
        return 'Çocuk';
    }
  }

  /// Get description in Turkish
  String get description {
    switch (this) {
      case UserRole.parent:
        return 'Çocuğunuzun cihazını kontrol edin ve yönetin';
      case UserRole.child:
        return 'Ebeveyn kontrolü altında güvenli kullanım';
    }
  }

  /// Get icon for role
  String get iconName {
    switch (this) {
      case UserRole.parent:
        return 'supervisor_account';
      case UserRole.child:
        return 'child_care';
    }
  }
} 