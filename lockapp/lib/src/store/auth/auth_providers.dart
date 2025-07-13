// Auth State Management Exports
export 'auth_state.dart';
export 'auth_notifier.dart';

// Provider shortcuts for easy access
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

// Convenient provider aliases
final authProvider = authNotifierProvider;
final authStateProvider = authNotifierProvider.select((state) => state);

// Specific state selectors for better performance
final isLoadingProvider = authNotifierProvider.select((state) => state.isLoading);
final isAuthenticatedProvider = authNotifierProvider.select((state) => state.isAuthenticated);
final currentUserProvider = authNotifierProvider.select((state) => state.user);
final authErrorProvider = authNotifierProvider.select((state) => state.error);
final isLoggedInProvider = authNotifierProvider.select((state) => state.isLoggedIn);
final isParentProvider = authNotifierProvider.select((state) => state.isParent);
final isChildProvider = authNotifierProvider.select((state) => state.isChild); 