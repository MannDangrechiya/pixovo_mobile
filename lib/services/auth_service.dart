import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';
import '../models/user.dart';
import 'api_service.dart';

/// Handles authentication operations — login, register, tokens.
class AuthService {
  final ApiService _api = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Login with email and password.
  /// Returns the authenticated [User] on success.
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      ApiConfig.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;
    await _storeTokens(data);
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  /// Register a new user account.
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      ApiConfig.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;
    await _storeTokens(data);
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  /// Logout the current user and clear stored tokens.
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  /// Request a password reset email.
  Future<void> forgotPassword({required String email}) async {
    await _api.post(
      ApiConfig.forgotPassword,
      data: {'email': email},
    );
  }

  /// Reset password with a token received via email.
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _api.post(
      ApiConfig.resetPassword,
      data: {
        'token': token,
        'password': newPassword,
      },
    );
  }

  /// Fetch the current user's profile using stored token.
  Future<User> getProfile() async {
    final response = await _api.get(ApiConfig.userProfile);
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  /// Check if the user is currently authenticated.
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  /// Retrieve the stored access token.
  Future<String?> getAccessToken() async {
    return _storage.read(key: 'access_token');
  }

  /// Store access and refresh tokens securely.
  Future<void> _storeTokens(Map<String, dynamic> data) async {
    if (data['access_token'] != null) {
      await _storage.write(
          key: 'access_token', value: data['access_token'] as String);
    }
    if (data['refresh_token'] != null) {
      await _storage.write(
          key: 'refresh_token', value: data['refresh_token'] as String);
    }
  }
}
