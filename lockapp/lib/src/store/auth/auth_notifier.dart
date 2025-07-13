import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lockapp/src/api/auth_service.dart';
import 'package:lockapp/src/api/auth_service_provider.dart';
import 'package:lockapp/src/store/auth/auth_state.dart';
import 'package:lockapp/src/types/user_model.dart';
import 'package:lockapp/src/types/enums/user_role.dart';
import 'package:lockapp/src/utils/error_handler.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);
    _initializeAuth();
    return const AuthState();
  }

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        state = state.copyWith(
          user: currentUser,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e);
      state = state.copyWith(
        error: errorMessage,
        isLoading: false,
        isAuthenticated: false,
      );
    }
  }

  /// Login user
  Future<bool> login({
    required String email,
    required String password,
    required UserRole expectedRole,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final user = await _authService.login(
        email: email,
        password: password,
        expectedRole: expectedRole,
      );
      
      if (user != null) {
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          error: 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e);
      state = state.copyWith(
        error: errorMessage,
        isLoading: false,
      );
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final user = await _authService.register(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      
      if (user != null) {
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          error: 'Kayıt başarısız. Lütfen tekrar deneyin.',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e);
      state = state.copyWith(
        error: errorMessage,
        isLoading: false,
      );
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _authService.logout();
      
      state = const AuthState(); // Reset to initial state
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e);
      state = state.copyWith(
        error: errorMessage,
        isLoading: false,
      );
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? profileImageUrl,
  }) async {
    if (state.user == null) return false;
    
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final updatedUser = await _authService.updateProfile(
        name: name,
        profileImageUrl: profileImageUrl,
      );
      
      if (updatedUser != null) {
        state = state.copyWith(
          user: updatedUser,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          error: 'Profil güncellenemedi. Lütfen tekrar deneyin.',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e);
      state = state.copyWith(
        error: errorMessage,
        isLoading: false,
      );
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword({required String email}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final success = await _authService.resetPassword(email: email);
      
      if (success) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
        return true;
      } else {
        state = state.copyWith(
          error: 'Şifre sıfırlama e-postası gönderilemedi.',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e);
      state = state.copyWith(
        error: errorMessage,
        isLoading: false,
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Refresh current user data
  Future<void> refreshUser() async {
    if (!state.isAuthenticated) return;
    
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        state = state.copyWith(
          user: currentUser,
          isLoading: false,
        );
      } else {
        // User session expired, logout
        await logout();
      }
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e);
      state = state.copyWith(
        error: errorMessage,
        isLoading: false,
      );
    }
  }
} 