import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lockapp/src/types/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    UserModel? user,
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    String? error,
  }) = _AuthState;

  const AuthState._();

  // Helper getters
  bool get hasError => error != null;
  bool get isLoggedIn => isAuthenticated && user != null;
  bool get isParent => user?.isParent ?? false;
  bool get isChild => user?.isChild ?? false;
} 