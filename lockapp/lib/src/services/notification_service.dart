import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lockapp/src/config/firebase_config.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseConfig.messaging;
  
  /// Initialize push notifications
  static Future<void> initialize() async {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    
    // Check for initial message (app opened from notification)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }
  
  /// Get FCM token for this device
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
  
  /// Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }
  
  /// Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
  
  /// Handle background messages
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Background message received: ${message.messageId}');
    
    // Handle different notification types
    final notificationType = message.data['type'];
    
    switch (notificationType) {
      case 'app_lock':
        await _handleAppLockNotification(message);
        break;
      case 'pairing_request':
        await _handlePairingRequest(message);
        break;
      case 'usage_alert':
        await _handleUsageAlert(message);
        break;
      default:
        print('Unknown notification type: $notificationType');
    }
  }
  
  /// Handle foreground messages
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Foreground message received: ${message.messageId}');
    
    // Show in-app notification or update UI
    // You can use a package like flutter_local_notifications for this
    
    final notification = message.notification;
    if (notification != null) {
      print('Title: ${notification.title}');
      print('Body: ${notification.body}');
    }
  }
  
  /// Handle notification tap
  static Future<void> _handleNotificationTap(RemoteMessage message) async {
    print('Notification tapped: ${message.messageId}');
    
    // Navigate to specific screen based on notification type
    final notificationType = message.data['type'];
    
    switch (notificationType) {
      case 'app_lock':
        // Navigate to app control screen
        break;
      case 'pairing_request':
        // Navigate to pairing screen
        break;
      case 'usage_alert':
        // Navigate to usage stats screen
        break;
    }
  }
  
  /// Handle app lock notification
  static Future<void> _handleAppLockNotification(RemoteMessage message) async {
    final packageName = message.data['package_name'];
    final action = message.data['action']; // 'lock' or 'unlock'
    
    print('App lock notification: $action for $packageName');
    
    // Here you would implement the actual app locking logic
    // This might involve calling your AccessibilityService
  }
  
  /// Handle pairing request
  static Future<void> _handlePairingRequest(RemoteMessage message) async {
    final parentId = message.data['parent_id'];
    final deviceName = message.data['device_name'];
    
    print('Pairing request from: $deviceName ($parentId)');
    
    // Show pairing request dialog or update UI
  }
  
  /// Handle usage alert
  static Future<void> _handleUsageAlert(RemoteMessage message) async {
    final appName = message.data['app_name'];
    final usageTime = message.data['usage_time'];
    
    print('Usage alert: $appName used for $usageTime minutes');
    
    // Show usage alert or update UI
  }
  
  /// Send notification to specific device
  static Future<void> sendNotificationToDevice({
    required String deviceToken,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    // This would typically be done from your backend
    // But you can use Firebase Admin SDK or HTTP API
    
    print('Sending notification to device: $deviceToken');
    print('Title: $title');
    print('Body: $body');
    print('Data: $data');
    
    // Implementation depends on your backend setup
  }
  
  /// Send notification to parent about child's activity
  static Future<void> notifyParentAboutChildActivity({
    required String parentToken,
    required String childName,
    required String appName,
    required int usageMinutes,
  }) async {
    await sendNotificationToDevice(
      deviceToken: parentToken,
      title: '$childName App Kullanımı',
      body: '$appName uygulamasını $usageMinutes dakika kullandı',
      data: {
        'type': 'usage_alert',
        'child_name': childName,
        'app_name': appName,
        'usage_time': usageMinutes.toString(),
      },
    );
  }
  
  /// Send app lock command to child device
  static Future<void> sendAppLockCommand({
    required String childDeviceToken,
    required String packageName,
    required String action, // 'lock' or 'unlock'
  }) async {
    await sendNotificationToDevice(
      deviceToken: childDeviceToken,
      title: 'Uygulama Kontrolü',
      body: action == 'lock' ? 'Uygulama kilitlendi' : 'Uygulama kilidi açıldı',
      data: {
        'type': 'app_lock',
        'package_name': packageName,
        'action': action,
      },
    );
  }
} 