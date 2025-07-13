import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lockapp/src/api/auth_service.dart';
import 'package:lockapp/src/types/user_model.dart';
import 'package:lockapp/src/types/enums/user_role.dart';
import 'package:lockapp/src/utils/error_handler.dart' as error_handler;

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
    required UserRole expectedRole,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Get user profile from Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          userData['id'] = credential.user!.uid;
          final user = UserModel.fromJson(userData);
          
          // Check if user role matches expected role
          if (user.role != expectedRole) {
            // Sign out the user since role doesn't match
            await _auth.signOut();
            throw error_handler.AuthException(
              'Access denied. This account is registered as ${user.role.name}. Please use the correct login section.'
            );
          }
          
          return user;
        } else {
          // If user document doesn't exist, sign out and throw error
          await _auth.signOut();
          throw error_handler.AuthException(
            'User profile not found. Please register first.'
          );
        }
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw error_handler.AuthException(_getAuthErrorMessage(e));
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
      // Check if email already exists with any role
      final existingUsers = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        throw error_handler.AuthException(
          'This email is already registered. Please use a different email address.'
        );
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(name);

        // Create user profile in Firestore
        final newUser = UserModel(
          id: credential.user!.uid,
          email: email,
          name: name,
          role: role,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(newUser.toJson());

        return newUser;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw error_handler.AuthException(_getAuthErrorMessage(e));
    } catch (e) {
      throw error_handler.AuthException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw error_handler.AuthException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Get user profile from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        userData['id'] = user.uid;
        return UserModel.fromJson(userData);
      }

      return null;
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
      final user = _auth.currentUser;
      if (user == null) {
        throw error_handler.AuthException('User not authenticated');
      }

      final updates = <String, dynamic>{
        'updated_at': FieldValue.serverTimestamp(),
      };

      if (name != null) {
        updates['name'] = name;
        await user.updateDisplayName(name);
      }
      if (profileImageUrl != null) {
        updates['profile_image_url'] = profileImageUrl;
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(updates);

      return await getCurrentUser();
    } catch (e) {
      throw error_handler.AuthException('Update profile failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      throw error_handler.AuthException(_getAuthErrorMessage(e));
    } catch (e) {
      throw error_handler.AuthException('Reset password failed: ${e.toString()}');
    }
  }

  /// Get Firebase Auth error message in Turkish
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Hatalı şifre girdiniz.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda.';
      case 'weak-password':
        return 'Şifre çok zayıf. En az 6 karakter olmalıdır.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'too-many-requests':
        return 'Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin.';
      case 'network-request-failed':
        return 'İnternet bağlantınızı kontrol edin.';
      case 'invalid-credential':
        return 'E-posta veya şifre hatalı.';
      default:
        return 'Bir hata oluştu: ${e.message}';
    }
  }

  /// Get auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current Firebase user
  User? get currentFirebaseUser => _auth.currentUser;
} 