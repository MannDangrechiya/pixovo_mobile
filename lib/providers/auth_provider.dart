import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

  /// Extracts a user-friendly error message from API error responses.
  /// Handles FastAPI validation errors (detail as List) and standard formats.
  String _extractErrorMessage(Map<String, dynamic> data) {
    // FastAPI returns detail as a List of validation errors
    final detail = data['detail'];
    if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is Map<String, dynamic>) {
        return first['msg'] as String? ?? first.toString();
      }
      return first.toString();
    }
    if (detail is String) return detail;

    // Other common API error formats
    if (data['message'] is String) return data['message'] as String;
    if (data['error'] is String) return data['error'] as String;
    if (data['msg'] is String) return data['msg'] as String;

    return data.toString();
  }

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
      String errorMessage = 'Login failed. Please try again.';

      if (e is DioException) {
        debugPrint('Login DioException: status=${e.response?.statusCode}, data=${e.response?.data}');
        if (e.response?.data != null) {
          final data = e.response!.data;
          if (data is Map<String, dynamic>) {
            errorMessage = _extractErrorMessage(data);
          } else {
            errorMessage = data.toString();
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
                   e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Connection timed out. Please check your internet.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'No internet connection.';
        }
      } else {
        debugPrint('Login error: $e');
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
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
      );
    } catch (e) {
      String errorMessage = 'Registration failed. Please try again.';

      if (e is DioException) {
        debugPrint('Register DioException: status=${e.response?.statusCode}, data=${e.response?.data}');
        if (e.response?.data != null) {
          final data = e.response!.data;
          if (data is Map<String, dynamic>) {
            errorMessage = _extractErrorMessage(data);
          } else {
            errorMessage = data.toString();
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
                   e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Connection timed out. Please check your internet.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'No internet connection.';
        }
      } else {
        debugPrint('Register error: $e');
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

  /// Proceed as guest.
  Future<void> guestLogin() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.guestRegister();
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
      );
    } catch (e) {
      String errorMessage = 'Guest login failed. Please try again.';

      if (e is DioException) {
        debugPrint('Guest Login DioException: status=${e.response?.statusCode}, data=${e.response?.data}');
        if (e.response?.data != null) {
          final data = e.response!.data;
          if (data is Map<String, dynamic>) {
            errorMessage = _extractErrorMessage(data);
          } else {
            errorMessage = data.toString();
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
                   e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Connection timed out. Please check your internet.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'No internet connection.';
        }
      } else {
        debugPrint('Guest Login error: $e');
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
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
