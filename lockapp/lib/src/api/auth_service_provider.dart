import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lockapp/src/api/auth_service.dart';
import 'package:lockapp/src/api/firebase_auth_service.dart';

part 'auth_service_provider.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) {
  return FirebaseAuthService();
} 