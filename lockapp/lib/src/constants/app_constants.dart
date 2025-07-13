class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Uygulama Kilidi';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Ebeveyn kontrol uygulaması';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String devicesCollection = 'devices';
  static const String usageStatsCollection = 'usage_stats';
  static const String lockCommandsCollection = 'lock_commands';
  static const String appListCollection = 'app_list';

  // User Roles
  static const String parentRole = 'parent';
  static const String childRole = 'child';

  // Device Types
  static const String parentDevice = 'parent_device';
  static const String childDevice = 'child_device';

  // Lock Status
  static const String lockStatusActive = 'active';
  static const String lockStatusInactive = 'inactive';
  static const String lockStatusPending = 'pending';

  // Usage Stats Time Periods
  static const String dailyPeriod = 'daily';
  static const String weeklyPeriod = 'weekly';
  static const String monthlyPeriod = 'monthly';

  // QR Code Settings
  static const int qrCodeSize = 200;
  static const String qrCodeVersion = 'v1.0';

  // Notification Settings
  static const String lockNotificationChannel = 'lock_notifications';
  static const String usageNotificationChannel = 'usage_notifications';
  static const String generalNotificationChannel = 'general_notifications';

  // Time Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // API Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Local Storage Keys
  static const String userIdKey = 'user_id';
  static const String userRoleKey = 'user_role';
  static const String deviceIdKey = 'device_id';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Error Messages
  static const String networkError = 'İnternet bağlantısı hatası';
  static const String authError = 'Kimlik doğrulama hatası';
  static const String permissionError = 'İzin hatası';
  static const String unknownError = 'Bilinmeyen hata';

  // Success Messages
  static const String loginSuccess = 'Giriş başarılı';
  static const String registerSuccess = 'Kayıt başarılı';
  static const String devicePairedSuccess = 'Cihaz başarıyla eşleştirildi';
  static const String appLockedSuccess = 'Uygulama kilitlendi';
  static const String appUnlockedSuccess = 'Uygulama kilidi kaldırıldı';

  // Chart Settings
  static const int maxChartDataPoints = 30;
  static const double chartAnimationDuration = 1.5;

  // Refresh Intervals (in seconds)
  static const int usageStatsRefreshInterval = 60;
  static const int lockStatusRefreshInterval = 30;
  static const int deviceStatusRefreshInterval = 120;

  // Limits
  static const int maxDevicesPerParent = 5;
  static const int maxAppsPerDevice = 100;
  static const int maxUsageHistoryDays = 30;

  // Default Values
  static const String defaultLanguage = 'tr';
  static const String defaultCountry = 'TR';
  static const bool defaultThemeMode = false; // false = light, true = dark
} 