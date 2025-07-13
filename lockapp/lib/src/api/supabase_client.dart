import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lockapp/src/config/supabase_config.dart';

class SupabaseClientProvider {
  static SupabaseClient? _instance;
  static bool _isInitialized = false;
  
  /// Get the Supabase client instance
  static SupabaseClient get instance {
    if (!_isInitialized) {
      throw Exception('Supabase client not initialized. Call initialize() first.');
    }
    _instance ??= Supabase.instance.client;
    return _instance!;
  }
  
  /// Initialize Supabase client
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Check configuration
    if (!SupabaseConfig.isConfigured) {
      throw Exception('Supabase configuration not set. Please update SupabaseConfig.');
    }
    
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: RealtimeLogLevel.info,
        ),
      );
      
      _isInitialized = true;
      print('✅ Supabase initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize Supabase: $e');
      rethrow;
    }
  }
  
  /// Check if client is initialized
  static bool get isInitialized => _isInitialized;
  
  /// Get current user session
  static Session? get currentSession => _instance?.auth.currentSession;
  
  /// Get current user
  static User? get currentUser => _instance?.auth.currentUser;
  
  /// Dispose client (for testing)
  static void dispose() {
    _instance = null;
    _isInitialized = false;
  }
} 