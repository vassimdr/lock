import 'package:lockapp/src/types/user_model.dart';
import 'package:lockapp/src/types/enums/user_role.dart';

/// Abstract authentication service interface
abstract class AuthService {
  /// Login with email and password
  Future<UserModel?> login({
    required String email,
    required String password,
  });
  
  /// Register new user
  Future<UserModel?> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  });
  
  /// Logout current user
  Future<void> logout();
  
  /// Get current authenticated user
  Future<UserModel?> getCurrentUser();
  
  /// Update user profile
  Future<UserModel?> updateProfile({
    String? name,
    String? profileImageUrl,
  });
  
  /// Reset password
  Future<bool> resetPassword({required String email});
} 