import 'package:flutter/foundation.dart';
import '../entities/user.dart';

class AuthStore extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(String username, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Call API here
      // final response = await AuthApi().login(LoginRequest(username: username, password: password));

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _user = User(id: '123', username: username, email: '$username@example.com');
      _token = 'simulated_jwt_token';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Call API here
      // final response = await AuthApi().register(RegisterRequest(username: username, email: email, password: password));

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _user = User(id: '123', username: username, email: email);
      _token = 'simulated_jwt_token';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    if (_token != null) {
      // Call API here
      // await AuthApi().logout(_token!);
    }

    _user = null;
    _token = null;
    notifyListeners();
  }

  bool get isAuthenticated => _token != null;
}