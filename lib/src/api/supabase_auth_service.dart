import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lockapp/src/api/auth_service.dart';
import 'package:lockapp/src/types/user_model.dart';
import 'package:lockapp/src/types/enums/user_role.dart';
import 'package:lockapp/src/utils/error_handler.dart' as error_handler;
import 'package:gotrue/gotrue.dart' as gotrue;

class SupabaseAuthService implements AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Get user profile from users table
        final userProfile = await _client
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();

        if (userProfile == null) {
          // User profile not found, create it automatically
          try {
            final newProfile = await _client.from('users').insert({
              'id': response.user!.id,
              'email': response.user!.email ?? email,
              'name': response.user!.userMetadata?['name'] ?? 'User',
              'role': 'parent', // Default role
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
              'is_active': true,
            }).select().single();

            return UserModel.fromJson(newProfile);
          } catch (e) {
            throw error_handler.AuthException('Could not create user profile: ${e.toString()}');
          }
        }

        return UserModel.fromJson(userProfile);
      }

      return null;
    } catch (e) {
      throw error_handler.AuthException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Check if user profile already exists
        final existingProfile = await _client
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();

        if (existingProfile != null) {
          // User profile already exists, return it
          return UserModel.fromJson(existingProfile);
        }

        // Create user profile in users table
        final userProfile = await _client.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'name': name,
          'role': role.value,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'is_active': true,
        }).select().single();

        return UserModel.fromJson(userProfile);
      }

      return null;
    } catch (e) {
      throw error_handler.AuthException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw error_handler.AuthException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      // Get user profile from users table
      final userProfile = await _client
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (userProfile == null) {
        throw error_handler.AuthException('User profile not found in database');
      }

      return UserModel.fromJson(userProfile);
    } catch (e) {
      throw error_handler.AuthException('Get current user failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> updateProfile({
    String? name,
    String? profileImageUrl,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw error_handler.AuthException('User not authenticated');
      }

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updates['name'] = name;
      if (profileImageUrl != null) updates['profile_image_url'] = profileImageUrl;

      final userProfile = await _client
          .from('users')
          .update(updates)
          .eq('id', user.id)
          .select()
          .maybeSingle();

      if (userProfile == null) {
        throw error_handler.AuthException('User profile not found');
      }

      return UserModel.fromJson(userProfile);
    } catch (e) {
      throw error_handler.AuthException('Update profile failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> resetPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      throw error_handler.AuthException('Reset password failed: ${e.toString()}');
    }
  }
} 