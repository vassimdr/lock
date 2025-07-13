import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

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
  /// Handle Firebase auth errors
  static AppException handleAuthError(dynamic error) {
    if (error is AuthException) {
      return AuthException(error.message);
    }
    
    if (error is firebase_auth.FirebaseAuthException) {
      return AuthException(_getFirebaseAuthErrorMessage(error));
    }
    
    if (error is firestore.FirebaseException) {
      return DatabaseException('Database error: ${error.message}');
    }
    
        return AuthException('Authentication failed: ${error.toString()}');
  }
  
  /// Get Firebase Auth error message in Turkish
  static String _getFirebaseAuthErrorMessage(firebase_auth.FirebaseAuthException e) {
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
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakılmış.';
      case 'operation-not-allowed':
        return 'Bu işlem şu anda izin verilmiyor.';
      default:
        return 'Bir hata oluştu: ${e.message}';
    }
  }
  
  /// Handle Firebase database errors
  static AppException handleDatabaseError(dynamic error) {
    if (error is firestore.FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return DatabaseException('Bu işlem için yetkiniz yok');
        case 'unavailable':
          return DatabaseException('Veritabanı şu anda kullanılamıyor');
        case 'deadline-exceeded':
          return DatabaseException('İşlem zaman aşımına uğradı');
        case 'not-found':
          return DatabaseException('Kayıt bulunamadı');
        case 'already-exists':
          return DatabaseException('Bu kayıt zaten mevcut');
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
    
    if (error is AuthException) {
      return handleAuthError(error).message;
    }
    
    if (error is firestore.FirebaseException) {
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
    
    if (error is AuthException) {
      return handleAuthError(error);
    }
    
    if (error is firestore.FirebaseException) {
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