import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'token_storage.dart';
import 'api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.instance;

  Future<int> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/users/login/',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final access = data['access'];
        final refresh = data['refresh'];

        if (access != null && refresh != null) {
          await TokenStorage().saveTokens(access, refresh);
          return data['user_id'] ?? 0;
        }
      } else {
        _logError('Login failed', response);
      }
    } catch (e) {
      _logException('Login exception', e);
    }
    return 0;
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/users/register/',
        data: {'name': name, 'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final access = data['access'];
        final refresh = data['refresh'];

        if (access != null && refresh != null) {
          await TokenStorage().saveTokens(access, refresh);
          return true;
        }
      } else {
        _logError('Registration failed', response);
      }
    } catch (e) {
      _logException('Registration exception', e);
    }
    return false;
  }

  Future<bool> googleLogin(String idToken) async {
    print('Google login initiated');
    try {
      final response = await _dio.post(
        '/api/users/google-login/',
        data: {'token': idToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final access = data['access'];
        final refresh = data['refresh'];

        if (access != null && refresh != null) {
          await TokenStorage().saveTokens(access, refresh);
          debugPrint('\x1B[32mGoogle login successful: ${data['message']}\x1B[0m');
          debugPrint('\x1B[34mUser Email: ${data['email']}, Name: ${data['name']}\x1B[0m');
          return true;
        }
      } else {
        debugPrint('\x1B[31mGoogle login failed: ${response.data}\x1B[0m');
      }
    } catch (e) {
      debugPrint('\x1B[31mGoogle login exception: $e\x1B[0m');
    }
    return false;
  }

  Future<int> getUserId() async {
    try {
      final accessToken = await TokenStorage().getAccessToken();
      if (accessToken != null) {
        final response = await _dio.get(
          '/api/users/get_user_id/',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );

        if (response.statusCode == 200) {
          final data = response.data;
          return data['user_id'] ?? 0;
        } else {
          _logError('Get user ID failed', response);
        }
      }
    } catch (e) {
      _logException('Get user ID exception', e);
    }
    return 0;
  }

  void _logError(String message, Response response) {
    print('$message: ${response.statusCode} - ${response.data}');
  }

  void _logException(String message, Object exception) {
    print('$message: $exception');
  }
}
