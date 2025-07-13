import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseConfig {
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;
  static FirebaseMessaging? _messaging;
  
  /// Initialize Firebase services
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      
      // Initialize Analytics
      _analytics = FirebaseAnalytics.instance;
      
      // Initialize Crashlytics
      _crashlytics = FirebaseCrashlytics.instance;
      
      // Initialize Messaging
      _messaging = FirebaseMessaging.instance;
      
      // Request notification permissions
      await _requestNotificationPermissions();
      
      print('✅ Firebase services initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize Firebase: $e');
      rethrow;
    }
  }
  
  /// Request notification permissions
  static Future<void> _requestNotificationPermissions() async {
    if (_messaging == null) return;
    
    final settings = await _messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    print('Notification permission status: ${settings.authorizationStatus}');
  }
  
  /// Get FCM token
  static Future<String?> getFCMToken() async {
    if (_messaging == null) return null;
    return await _messaging!.getToken();
  }
  
  /// Analytics instance
  static FirebaseAnalytics get analytics {
    if (_analytics == null) {
      throw Exception('Firebase Analytics not initialized');
    }
    return _analytics!;
  }
  
  /// Crashlytics instance
  static FirebaseCrashlytics get crashlytics {
    if (_crashlytics == null) {
      throw Exception('Firebase Crashlytics not initialized');
    }
    return _crashlytics!;
  }
  
  /// Messaging instance
  static FirebaseMessaging get messaging {
    if (_messaging == null) {
      throw Exception('Firebase Messaging not initialized');
    }
    return _messaging!;
  }
  
  /// Log custom event
  static Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    await analytics.logEvent(
      name: name, 
      parameters: parameters?.cast<String, Object>(),
    );
  }
  
  /// Log error to Crashlytics
  static Future<void> logError(dynamic exception, StackTrace? stackTrace) async {
    await crashlytics.recordError(exception, stackTrace);
  }
  
  /// Set user properties
  static Future<void> setUserProperties({
    required String userId,
    required String userRole,
  }) async {
    await analytics.setUserId(id: userId);
    await analytics.setUserProperty(name: 'user_role', value: userRole);
    await crashlytics.setUserIdentifier(userId);
  }
} 