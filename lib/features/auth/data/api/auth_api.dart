import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/ApiConstants.dart';
import '../entities/auth_response.dart';
import '../entities/login_response.dart';
import '../entities/register_request.dart';

class AuthApi {
  final http.Client client;

  AuthApi({required this.client});

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/login'),
      body: json.encode(request.toJson()),
      headers: {
        'Content-Type': 'application/json'}
      );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];

      return AuthResponse(token: token,);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/register'),
      body: json.encode(request.toJson()),
      headers: {
        'Content-Type': 'application/json'}
      );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];

      return AuthResponse(token: token);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }
}

//fixed