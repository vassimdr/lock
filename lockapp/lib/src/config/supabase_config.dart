class SupabaseConfig {
  // Supabase project URL
  static const String url = 'https://fdswzdxemrfhqobavywx.supabase.co';
  
  // Supabase anon key
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZkc3d6ZHhlbXJmaHFvYmF2eXd4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI0MTQzODIsImV4cCI6MjA2Nzk5MDM4Mn0.jk8W-yEkZxOdCY6ax437DGMmVQQZQo3ty8SrbmjS8RY';
  
  // Environment check
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  
  // Database configuration
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Auth configuration
  static const bool autoRefreshToken = true;
  static const bool persistSession = true;
  
  // Validation
  static bool get isConfigured => 
      url != 'https://your-project-id.supabase.co' && 
      anonKey != 'your-anon-key-here';
} 