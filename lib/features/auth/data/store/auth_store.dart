import 'dart:convert';

import 'package:digital_wind/features/auth/data/entities/login_response.dart';
import 'package:digital_wind/features/auth/data/entities/register_request.dart';
import 'package:digital_wind/features/core/entities/store_status.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../api/auth_api.dart';


class AuthStore extends ChangeNotifier {
  String? _token;
  StoreStatus _status = StoreStatus.success;
  final AuthApi authApi = AuthApi(client: http.Client());

  String? get token => _token;
  bool get isAuthenticated => _token != null;

  Future<void> login(LoginRequest request) async {
    try {
      // loading 
      _status = StoreStatus.loading;
      notifyListeners();

      //fetch data
      final response = await authApi.login(request);

      //successful login
      _token = response.token;
      _status = StoreStatus.success;
      notifyListeners();
      
      
    } catch (e) {
      //error during login
      _status = StoreStatus.error;
      notifyListeners();
    } 
  }

  Future<void> register(RegisterRequest request) async {
    try {
      print("go");
      //loading
      _status = StoreStatus.loading;
      notifyListeners();

      //fetch data
      final response = await authApi.register(request);

      //successful register
      _token = response.token;
      _status = StoreStatus.success;
      notifyListeners();

    } catch (e) {
      //error during register
      _status = StoreStatus.error;
      notifyListeners();
    }
  }

  // fixed
}