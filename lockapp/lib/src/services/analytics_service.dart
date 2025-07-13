import 'package:lockapp/src/config/firebase_config.dart';
import 'package:lockapp/src/types/enums/user_role.dart';

class AnalyticsService {
  /// Log user login event
  static Future<void> logLogin({
    required String method,
    required UserRole userRole,
  }) async {
    await FirebaseConfig.logEvent('login', parameters: {
      'method': method,
      'user_role': userRole.value,
    });
  }
  
  /// Log user registration event
  static Future<void> logSignUp({
    required String method,
    required UserRole userRole,
  }) async {
    await FirebaseConfig.logEvent('sign_up', parameters: {
      'method': method,
      'user_role': userRole.value,
    });
  }
  
  /// Log device pairing event
  static Future<void> logDevicePairing({
    required String parentDeviceId,
    required String childDeviceId,
    required bool isSuccessful,
  }) async {
    await FirebaseConfig.logEvent('device_pairing', parameters: {
      'parent_device_id': parentDeviceId,
      'child_device_id': childDeviceId,
      'is_successful': isSuccessful,
    });
  }
  
  /// Log app lock/unlock event
  static Future<void> logAppLockAction({
    required String packageName,
    required String appName,
    required String action, // 'lock' or 'unlock'
    required String parentUserId,
    required String childUserId,
  }) async {
    await FirebaseConfig.logEvent('app_lock_action', parameters: {
      'package_name': packageName,
      'app_name': appName,
      'action': action,
      'parent_user_id': parentUserId,
      'child_user_id': childUserId,
    });
  }
  
  /// Log app usage tracking
  static Future<void> logAppUsage({
    required String packageName,
    required String appName,
    required int usageMinutes,
    required String userId,
  }) async {
    await FirebaseConfig.logEvent('app_usage', parameters: {
      'package_name': packageName,
      'app_name': appName,
      'usage_minutes': usageMinutes,
      'user_id': userId,
    });
  }
  
  /// Log screen view
  static Future<void> logScreenView({
    required String screenName,
    required String screenClass,
  }) async {
    await FirebaseConfig.logEvent('screen_view', parameters: {
      'screen_name': screenName,
      'screen_class': screenClass,
    });
  }
  
  /// Log permission request
  static Future<void> logPermissionRequest({
    required String permissionType,
    required bool isGranted,
  }) async {
    await FirebaseConfig.logEvent('permission_request', parameters: {
      'permission_type': permissionType,
      'is_granted': isGranted,
    });
  }
  
  /// Log error event
  static Future<void> logError({
    required String errorType,
    required String errorMessage,
    required String? userId,
  }) async {
    await FirebaseConfig.logEvent('app_error', parameters: {
      'error_type': errorType,
      'error_message': errorMessage,
      'user_id': userId ?? 'unknown',
    });
    
    // Also log to Crashlytics
    await FirebaseConfig.logError(
      Exception('$errorType: $errorMessage'),
      StackTrace.current,
    );
  }
  
  /// Log QR code scan event
  static Future<void> logQRCodeScan({
    required bool isSuccessful,
    required String? errorMessage,
  }) async {
    await FirebaseConfig.logEvent('qr_code_scan', parameters: {
      'is_successful': isSuccessful,
      'error_message': errorMessage ?? 'none',
    });
  }
  
  /// Log notification interaction
  static Future<void> logNotificationInteraction({
    required String notificationType,
    required String action, // 'received', 'opened', 'dismissed'
  }) async {
    await FirebaseConfig.logEvent('notification_interaction', parameters: {
      'notification_type': notificationType,
      'action': action,
    });
  }
  
  /// Set user properties for analytics
  static Future<void> setUserProperties({
    required String userId,
    required UserRole userRole,
    required int deviceCount,
    required bool hasActiveSubscription,
  }) async {
    await FirebaseConfig.setUserProperties(
      userId: userId,
      userRole: userRole.value,
    );
    
    // Set additional custom properties
    await FirebaseConfig.analytics.setUserProperty(
      name: 'device_count',
      value: deviceCount.toString(),
    );
    
    await FirebaseConfig.analytics.setUserProperty(
      name: 'has_active_subscription',
      value: hasActiveSubscription.toString(),
    );
  }
  
  /// Log app performance metrics
  static Future<void> logPerformanceMetric({
    required String metricName,
    required double value,
    required String unit,
  }) async {
    await FirebaseConfig.logEvent('performance_metric', parameters: {
      'metric_name': metricName,
      'value': value,
      'unit': unit,
    });
  }
  
  /// Log feature usage
  static Future<void> logFeatureUsage({
    required String featureName,
    required UserRole userRole,
  }) async {
    await FirebaseConfig.logEvent('feature_usage', parameters: {
      'feature_name': featureName,
      'user_role': userRole.value,
    });
  }
} 