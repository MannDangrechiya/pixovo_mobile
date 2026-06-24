import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';
import '../models/user.dart';
import 'api_service.dart';

/// Handles authentication operations — login, register, tokens.
class AuthService {
  final ApiService _api = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Extracts the payload from an API response, unwrapping
  /// nested structures like `{status: ..., data: {...}}`.
  Map<String, dynamic> _unwrapResponse(dynamic responseData) {
    final data = responseData as Map<String, dynamic>;
    // If the response has a nested 'data' key, unwrap it
    if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
      return data['data'] as Map<String, dynamic>;
    }
    return data;
  }

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
        'temp_user_id': '',
      },
    );

    developer.log('Login response: ${response.data}', name: 'AuthService');

    final data = _unwrapResponse(response.data);
    await _storeTokens(data);

    // 'user' may be nested under a key or at the top level
    final userJson = data['user'] as Map<String, dynamic>? ?? data;
    return User.fromJson(userJson);
  }

  /// Register a new user account.
  /// Register a new user account.
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // 1. Split the single Full Name into First and Last names
    final nameParts = name.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final response = await _api.post(
      ApiConfig.register,
      data: {
        'first_name': firstName, // ✅ Matches backend
        'last_name': lastName, // ✅ Matches backend
        'email': email,
        'password': password,
        'type': 'web', // Sometimes required by the backend
        'temp_user_id': '',
      },
    );

    final data = response.data as Map<String, dynamic>;

    developer.log('Register response: ${response.data}', name: 'AuthService');

    final unwrapped = _unwrapResponse(data);
    await _storeTokens(unwrapped);

    final userJson = unwrapped['user'] as Map<String, dynamic>? ?? unwrapped;
    return User.fromJson(userJson);
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
    // Some APIs return 'token' instead of 'access_token'
    final accessToken = data['access_token'] ?? data['token'];
    if (accessToken != null) {
      developer.log('Storing access token', name: 'AuthService');
      await _storage.write(
          key: 'access_token', value: accessToken.toString());
    } else {
      developer.log('WARNING: No access_token or token found in response. Keys: ${data.keys.toList()}', name: 'AuthService');
    }
    if (data['refresh_token'] != null) {
      await _storage.write(
          key: 'refresh_token', value: data['refresh_token'] as String);
    }
  }
}
