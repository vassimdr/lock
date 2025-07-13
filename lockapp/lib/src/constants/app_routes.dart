class AppRoutes {
  AppRoutes._();

  // Root Routes
  static const String root = '/';
  static const String splash = '/splash';

  // Authentication Routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Onboarding Routes
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';

  // Parent App Routes
  static const String parentDashboard = '/parent-dashboard';
  static const String deviceList = '/device-list';
  static const String deviceDetails = '/device-details';
  static const String devicePairing = '/device-pairing';
  static const String qrScanner = '/qr-scanner';
  static const String usageStats = '/usage-stats';
  static const String appLocking = '/app-locking';
  static const String parentSettings = '/parent-settings';
  static const String parentProfile = '/parent-profile';

  // Child App Routes
  static const String childDashboard = '/child-dashboard';
  static const String childSettings = '/child-settings';
  static const String childProfile = '/child-profile';
  static const String lockScreen = '/lock-screen';
  
  // Permission Routes
  static const String permissions = '/permissions';

  // Common Routes
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String help = '/help';
  static const String about = '/about';
  static const String privacy = '/privacy';
  static const String terms = '/terms';

  // Error Routes
  static const String error = '/error';
  static const String notFound = '/not-found';

  // Route Names for Navigation
  static const String loginRouteName = 'login';
  static const String registerRouteName = 'register';
  static const String forgotPasswordRouteName = 'forgot-password';
  static const String resetPasswordRouteName = 'reset-password';
  static const String onboardingRouteName = 'onboarding';
  static const String roleSelectionRouteName = 'role-selection';
  static const String parentDashboardRouteName = 'parent-dashboard';
  static const String deviceListRouteName = 'device-list';
  static const String deviceDetailsRouteName = 'device-details';
  static const String devicePairingRouteName = 'device-pairing';
  static const String qrScannerRouteName = 'qr-scanner';
  static const String usageStatsRouteName = 'usage-stats';
  static const String appLockingRouteName = 'app-locking';
  static const String parentSettingsRouteName = 'parent-settings';
  static const String parentProfileRouteName = 'parent-profile';
  static const String childDashboardRouteName = 'child-dashboard';
  static const String childSettingsRouteName = 'child-settings';
  static const String childProfileRouteName = 'child-profile';
  static const String lockScreenRouteName = 'lock-screen';
  static const String permissionsRouteName = 'permissions';
  static const String settingsRouteName = 'settings';
  static const String profileRouteName = 'profile';
  static const String helpRouteName = 'help';
  static const String aboutRouteName = 'about';
  static const String privacyRouteName = 'privacy';
  static const String termsRouteName = 'terms';
  static const String errorRouteName = 'error';
  static const String notFoundRouteName = 'not-found';

  // Route Parameters
  static const String deviceIdParam = 'deviceId';
  static const String appIdParam = 'appId';
  static const String userIdParam = 'userId';
  static const String errorMessageParam = 'errorMessage';
  static const String returnUrlParam = 'returnUrl';

  // Deep Link Prefixes
  static const String deepLinkPrefix = 'lockapp://';
  static const String webLinkPrefix = 'https://lockapp.com/';

  // Route Groups
  static const List<String> authRoutes = [
    login,
    register,
    forgotPassword,
    resetPassword,
  ];

  static const List<String> parentRoutes = [
    parentDashboard,
    deviceList,
    deviceDetails,
    devicePairing,
    qrScanner,
    usageStats,
    appLocking,
    parentSettings,
    parentProfile,
  ];

  static const List<String> childRoutes = [
    childDashboard,
    childSettings,
    childProfile,
    lockScreen,
  ];

  static const List<String> publicRoutes = [
    splash,
    onboarding,
    roleSelection,
    help,
    about,
    privacy,
    terms,
    error,
    notFound,
  ];

  // Route Validation
  static bool isAuthRoute(String route) => authRoutes.contains(route);
  static bool isParentRoute(String route) => parentRoutes.contains(route);
  static bool isChildRoute(String route) => childRoutes.contains(route);
  static bool isPublicRoute(String route) => publicRoutes.contains(route);
  static bool isProtectedRoute(String route) => 
      isParentRoute(route) || isChildRoute(route);
} 