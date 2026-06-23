import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

/// Auth state model.
class AuthState {
  final User? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
    );
  }
}

/// Manages authentication state across the app.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  /// Attempt login with email/password.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.login(
        email: email,
        password: password,
      );
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
      );
    } catch (e) {
      String errorMessage = e.toString();

      // If it's a DioException, extract the actual FastAPI validation error
      if (e is DioException && e.response?.data != null) {
        errorMessage = e.response?.data.toString() ?? 'Server Error';
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
    }
  }

  /// Register a new account.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
      );
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
      );
    } catch (e) {
      String errorMessage = e.toString();

      // If it's a DioException, extract the actual FastAPI validation error
      if (e is DioException && e.response?.data != null) {
        errorMessage = e.response?.data.toString() ?? 'Server Error';
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
    }
  }

  /// Logout the current user.
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.logout();
    } finally {
      state = const AuthState();
    }
  }

  /// Check existing auth status (e.g., on app start).
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        final user = await _authService.getProfile();
        state = state.copyWith(
          user: user,
          isLoading: false,
          isAuthenticated: true,
        );
      } else {
        state = state.copyWith(isLoading: false, isAuthenticated: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isAuthenticated: false);
    }
  }

  /// Clear any displayed error message.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for the AuthService.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider for the AuthNotifier (StateNotifier).
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});
