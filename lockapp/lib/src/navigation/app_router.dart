import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/role_selection_screen.dart';
import '../screens/parent/parent_dashboard_screen.dart';
import '../screens/child/child_dashboard_screen.dart';
import '../screens/permissions/permission_screen.dart';
import '../screens/common/error_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    
    // Error handling
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error?.toString() ?? 'Unknown error',
    ),
    
    // Route definitions
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginRouteName,
        builder: (context, state) => const LoginScreen(),
      ),
      
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerRouteName,
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Onboarding Routes
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingRouteName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      GoRoute(
        path: AppRoutes.roleSelection,
        name: AppRoutes.roleSelectionRouteName,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      
      // Parent Routes
      GoRoute(
        path: AppRoutes.parentDashboard,
        name: AppRoutes.parentDashboardRouteName,
        builder: (context, state) => const ParentDashboardScreen(),
      ),
      
      // Child Routes
      GoRoute(
        path: AppRoutes.childDashboard,
        name: AppRoutes.childDashboardRouteName,
        builder: (context, state) => const ChildDashboardScreen(),
      ),
      
      // Permission Routes
      GoRoute(
        path: AppRoutes.permissions,
        name: AppRoutes.permissionsRouteName,
        builder: (context, state) => const PermissionScreen(),
      ),
      
      // Error Route
      GoRoute(
        path: AppRoutes.error,
        name: AppRoutes.errorRouteName,
        builder: (context, state) => ErrorScreen(
          error: state.uri.queryParameters['message'] ?? 'Unknown error',
        ),
      ),
    ],
    
    // Route redirect logic
    redirect: (context, state) {
      // TODO: Implement authentication and role-based redirects
      // For now, we'll handle basic routing
      
      // final isOnSplash = state.matchedLocation == AppRoutes.splash;
      // final isOnAuth = AppRoutes.isAuthRoute(state.matchedLocation);
      // final isOnOnboarding = state.matchedLocation == AppRoutes.onboarding ||
      //                       state.matchedLocation == AppRoutes.roleSelection;
      
      // TODO: Check if user is authenticated
      // final isAuthenticated = await checkUserAuthentication();
      
      // TODO: Check if user has completed onboarding
      // final hasCompletedOnboarding = await checkOnboardingStatus();
      
      // TODO: Get user role
      // final userRole = await getUserRole();
      
      // For now, allow all routes
      return null;
    },
  );
  
  // Navigation helper methods
  static void goToLogin() {
    router.goNamed(AppRoutes.loginRouteName);
  }
  
  static void goToRegister() {
    router.goNamed(AppRoutes.registerRouteName);
  }
  
  static void goToOnboarding() {
    router.goNamed(AppRoutes.onboardingRouteName);
  }
  
  static void goToRoleSelection() {
    router.goNamed(AppRoutes.roleSelectionRouteName);
  }
  
  static void goToParentDashboard() {
    router.goNamed(AppRoutes.parentDashboardRouteName);
  }
  
  static void goToChildDashboard() {
    router.goNamed(AppRoutes.childDashboardRouteName);
  }
  
  static void goToPermissions() {
    router.goNamed(AppRoutes.permissionsRouteName);
  }
  
  static void goToError(String message) {
    router.goNamed(
      AppRoutes.errorRouteName,
      queryParameters: {'message': message},
    );
  }
  
  // Note: Use Navigator.of(context).pop() instead of router.pop() 
  // for better context-aware navigation
} 