import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

class PermissionService {
  PermissionService._();

  static const MethodChannel _channel = MethodChannel('com.lockapp.lockapp/permissions');

  // Critical permissions for parental control app (only supported ones)
  static const List<permission_handler.Permission> _criticalPermissions = [
    permission_handler.Permission.systemAlertWindow, // Üstte Gösterme İzni
    // Note: Other permissions need native implementation or manual settings redirect
  ];

  /// Check if all critical permissions are granted
  static Future<bool> areAllPermissionsGranted() async {
    // Flutter desteklenen izinleri kontrol et
    for (final permission in _criticalPermissions) {
      if (!await permission.isGranted) {
        return false;
      }
    }
    
    // Native Android izinlerini kontrol et
    final usageAccess = await checkUsageAccessPermission();
    final accessibility = await checkAccessibilityPermission();
    final deviceAdmin = await checkDeviceAdminPermission();
    final overlay = await checkOverlayPermission();
    
    return usageAccess && accessibility && deviceAdmin && overlay;
  }

  /// Request all critical permissions
  static Future<Map<permission_handler.Permission, permission_handler.PermissionStatus>> requestAllPermissions() async {
    Map<permission_handler.Permission, permission_handler.PermissionStatus> statuses = {};
    
    for (final permission in _criticalPermissions) {
      statuses[permission] = await permission.request();
    }
    
    return statuses;
  }

  /// Check specific permission status
  static Future<permission_handler.PermissionStatus> checkPermission(permission_handler.Permission permission) async {
    return await permission.status;
  }

  /// Request specific permission
  static Future<permission_handler.PermissionStatus> requestPermission(permission_handler.Permission permission) async {
    return await permission.request();
  }

  /// Get permission name for UI
  static String getPermissionName(permission_handler.Permission permission) {
    switch (permission) {
      case permission_handler.Permission.systemAlertWindow:
        return 'Üstte Gösterme İzni';
      default:
        return 'Bilinmeyen İzin';
    }
  }

  /// Get permission description for UI
  static String getPermissionDescription(permission_handler.Permission permission) {
    switch (permission) {
      case permission_handler.Permission.systemAlertWindow:
        return 'Uygulama kilidi ekranını göstermek için gerekli';
      default:
        return 'Bu izin gerekli';
    }
  }

  /// Get permission icon for UI
  static String getPermissionIcon(permission_handler.Permission permission) {
    switch (permission) {
      case permission_handler.Permission.systemAlertWindow:
        return '🖥️';
      default:
        return '❓';
    }
  }

  /// Check if permission is permanently denied
  static Future<bool> isPermanentlyDenied(permission_handler.Permission permission) async {
    return await permission.isPermanentlyDenied;
  }

  /// Open app settings - Native Android method
  static Future<bool> openAppSettings() async {
    try {
      await _channel.invokeMethod('openAppSettings');
      return true;
    } catch (e) {
      print('Uygulama ayarları açılamadı: $e');
      // Fallback to permission_handler
      return await permission_handler.openAppSettings();
    }
  }

  /// Open Usage Access Settings - Native Android method
  static Future<void> openUsageAccessSettings() async {
    try {
      await _channel.invokeMethod('openUsageAccessSettings');
    } catch (e) {
      print('Kullanım erişimi ayarları açılamadı: $e');
      await openAppSettings();
    }
  }

  /// Open Accessibility Settings - Native Android method
  static Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } catch (e) {
      print('Erişilebilirlik ayarları açılamadı: $e');
      await openAppSettings();
    }
  }

  /// Open Device Admin Settings - Native Android method
  static Future<void> openDeviceAdminSettings() async {
    try {
      await _channel.invokeMethod('openDeviceAdminSettings');
    } catch (e) {
      print('Cihaz yöneticisi ayarları açılamadı: $e');
      await openAppSettings();
    }
  }

  /// Open System Alert Window Settings (Overlay permissions) - Native Android method
  static Future<void> openSystemAlertWindowSettings() async {
    try {
      await _channel.invokeMethod('openOverlaySettings');
    } catch (e) {
      print('Üstte gösterme ayarları açılamadı: $e');
      await openAppSettings();
    }
  }

  /// Native Android izin kontrol metodları
  static Future<bool> checkUsageAccessPermission() async {
    try {
      return await _channel.invokeMethod('checkUsageAccessPermission');
    } catch (e) {
      print('Usage access izin kontrolü başarısız: $e');
      return false;
    }
  }

  static Future<bool> checkAccessibilityPermission() async {
    try {
      return await _channel.invokeMethod('checkAccessibilityPermission');
    } catch (e) {
      print('Accessibility izin kontrolü başarısız: $e');
      return false;
    }
  }

  static Future<bool> checkDeviceAdminPermission() async {
    try {
      return await _channel.invokeMethod('checkDeviceAdminPermission');
    } catch (e) {
      print('Device admin izin kontrolü başarısız: $e');
      return false;
    }
  }

  static Future<bool> checkOverlayPermission() async {
    try {
      return await _channel.invokeMethod('checkOverlayPermission');
    } catch (e) {
      print('Overlay izin kontrolü başarısız: $e');
      return false;
    }
  }

  /// Otomatik izin isteme metodları
  static Future<void> requestAccessibilityPermission() async {
    try {
      await _channel.invokeMethod('requestAccessibilityPermission');
    } catch (e) {
      print('Accessibility izin isteme başarısız: $e');
      await openAccessibilitySettings();
    }
  }

  static Future<void> requestDeviceAdminPermission() async {
    try {
      await _channel.invokeMethod('requestDeviceAdminPermission');
    } catch (e) {
      print('Device admin izin isteme başarısız: $e');
      await openDeviceAdminSettings();
    }
  }

  /// Get all critical permissions list
  static List<permission_handler.Permission> get criticalPermissions => _criticalPermissions;
} 