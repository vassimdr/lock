import 'package:supabase_flutter/supabase_flutter.dart';

/// Base application exception
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Authentication specific exceptions
class AuthException extends AppException {
  AuthException(String message, {String? code, dynamic originalError})
      : super(message, code: code ?? 'AUTH_ERROR', originalError: originalError);
}

/// Database specific exceptions
class DatabaseException extends AppException {
  DatabaseException(String message, {String? code, dynamic originalError})
      : super(message, code: code ?? 'DATABASE_ERROR', originalError: originalError);
}

/// Network specific exceptions
class NetworkException extends AppException {
  NetworkException(String message, {String? code, dynamic originalError})
      : super(message, code: code ?? 'NETWORK_ERROR', originalError: originalError);
}

/// Error handler utility class
class ErrorHandler {
  /// Handle Supabase auth errors
  static AppException handleAuthError(dynamic error) {
    if (error is AuthException) {
      return AuthException(error.message);
    }
    
    // Handle Supabase AuthApiException
    if (error.toString().contains('AuthApiException')) {
      final errorString = error.toString();
      
      // Email rate limit error
      if (errorString.contains('over_email_send_rate_limit')) {
        return AuthException('Güvenlik nedeniyle e-posta gönderimi sınırlandı. Lütfen 60 saniye bekleyin.');
      }
      
      // Email already registered
      if (errorString.contains('User already registered')) {
        return AuthException('Bu e-posta adresi zaten kayıtlı. Giriş yapmayı deneyin.');
      }
      
      // Invalid credentials
      if (errorString.contains('Invalid login credentials')) {
        return AuthException('E-posta veya şifre hatalı. Lütfen kontrol edin.');
      }
      
      // Email not confirmed
      if (errorString.contains('Email not confirmed')) {
        return AuthException('E-posta adresinizi onaylamanız gerekiyor. Gelen kutunuzu kontrol edin.');
      }
      
      // Weak password
      if (errorString.contains('Password should be at least')) {
        return AuthException('Şifre en az 6 karakter olmalıdır.');
      }
      
      // Generic auth error
      return AuthException('Kimlik doğrulama hatası. Lütfen tekrar deneyin.');
    }
    
    if (error is PostgrestException) {
      return DatabaseException('Database error: ${error.message}');
    }
    
    return AuthException('Authentication failed: ${error.toString()}');
  }
  
  /// Handle Supabase database errors
  static AppException handleDatabaseError(dynamic error) {
    if (error is PostgrestException) {
      switch (error.code) {
        case '23505': // Unique constraint violation
          return DatabaseException('Bu kayıt zaten mevcut');
        case '23503': // Foreign key constraint violation
          return DatabaseException('İlişkili kayıt bulunamadı');
        case '42501': // Insufficient privilege / RLS policy violation
          if (error.message.contains('row-level security policy')) {
            return DatabaseException('Hesap oluşturma hatası. Lütfen daha sonra tekrar deneyin.');
          }
          return DatabaseException('Bu işlem için yetkiniz yok');
        case 'PGRST116': // JSON object requested, multiple (or no) rows returned
          return DatabaseException('Kullanıcı profili bulunamadı veya birden fazla kayıt mevcut');
        default:
          return DatabaseException('Veritabanı hatası: ${error.message}');
      }
    }
    
    return DatabaseException('Veritabanı hatası: ${error.toString()}');
  }
  
  /// Handle network errors
  static AppException handleNetworkError(dynamic error) {
    final message = error.toString().toLowerCase();
    
    if (message.contains('timeout')) {
      return NetworkException('Bağlantı zaman aşımına uğradı');
    }
    
    if (message.contains('no internet') || message.contains('network')) {
      return NetworkException('İnternet bağlantısı yok');
    }
    
    return NetworkException('Ağ hatası: ${error.toString()}');
  }
  
  /// Generic error handler - returns string message
  static String handleError(dynamic error) {
    if (error is AppException) {
      return error.message;
    }
    
    // Handle Supabase AuthApiException specifically
    if (error.toString().contains('AuthApiException')) {
      return handleAuthError(error).message;
    }
    
    if (error is AuthException) {
      return handleAuthError(error).message;
    }
    
    if (error is PostgrestException) {
      return handleDatabaseError(error).message;
    }
    
    // Check for network-related errors
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('timeout') || 
        errorString.contains('network') || 
        errorString.contains('connection')) {
      return handleNetworkError(error).message;
    }
    
    return 'Bilinmeyen hata: ${error.toString()}';
  }
  
  /// Generic error handler - returns AppException
  static AppException handleErrorException(dynamic error) {
    if (error is AppException) {
      return error;
    }
    
    // Handle Supabase AuthApiException specifically
    if (error.toString().contains('AuthApiException')) {
      return handleAuthError(error);
    }
    
    if (error is AuthException) {
      return handleAuthError(error);
    }
    
    if (error is PostgrestException) {
      return handleDatabaseError(error);
    }
    
    // Check for network-related errors
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('timeout') || 
        errorString.contains('network') || 
        errorString.contains('connection')) {
      return handleNetworkError(error);
    }
    
    return AppException('Bilinmeyen hata: ${error.toString()}');
  }
  
  /// Log error for debugging
  static void logError(dynamic error, [StackTrace? stackTrace]) {
    print('🔥 Error: $error');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }
} 