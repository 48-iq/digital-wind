import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../api/auth_api.dart';
import '../entities/auth_response.dart';
import '../entities/user.dart';

class AuthStore extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;
  final AuthApi _authApi;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthStore({AuthApi? authApi}) : _authApi = authApi ?? AuthApi(client: http.Client());

  Future<void> login(String username, String password) async {
    try {
      _startLoading();

      /*
      final response = await _authApi.login(
        LoginRequest(username: username, password: password),
      );
      _handleAuthResponse(response);
      */

      // Потом удалить
      await Future.delayed(const Duration(milliseconds: 500));
      _token = 'temp_token_${username.hashCode}';
      _user = User(
        id: 'temp_user_${username.hashCode}',
        username: username,
        email: '$username@temp.com',
      );
      notifyListeners();

    } catch (e) {
      _handleError(e);
    } finally {
      _stopLoading();
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      _startLoading();

      // Реальная логика (закомментирована)
      /*
      final response = await _authApi.register(
        RegisterRequest(username: username, email: email, password: password),
      );
      _handleAuthResponse(response);
      */

      // Потом удалить
      await Future.delayed(const Duration(milliseconds: 500));
      _token = 'temp_token_${username.hashCode}';
      _user = User(
        id: 'temp_user_${username.hashCode}',
        username: username,
        email: email,
      );
      notifyListeners();

    } catch (e) {
      _handleError(e);
    } finally {
      _stopLoading();
    }
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        // await _authApi.logout(_token!);
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _clearAuthData();
    }
  }

  bool get isAuthenticated => _token != null;

  void _startLoading() {
    _isLoading = true;
    _error = null;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void _handleError(dynamic error) {
    _error = error.toString();
    notifyListeners();
  }

  void _handleAuthResponse(AuthResponse response) {
    _token = response.token;
    _user = response.user as User?;

    if (!_validateJwt(response.token, response.user.id)) {
      throw Exception('Invalid JWT token');
    }
  }

  bool _validateJwt(String token, String userId) {
    try {
      final decoded = JwtDecoder.decode(token);
      final jwtUserId = decoded['sub'] ?? decoded['userId'];
      return jwtUserId == userId;
    } catch (e) {
      return false;
    }
  }

  void _clearAuthData() {
    _user = null;
    _token = null;
    notifyListeners();
  }
}