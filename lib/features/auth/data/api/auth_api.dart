import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../core/constants/app_constants.dart';
import '../entities/User.dart';
import '../entities/auth_response.dart';
import '../entities/login_request.dart';
import '../entities/register_request.dart';

class AuthApi {
  final http.Client client;

  AuthApi({required this.client});

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/login'),
      body: json.encode(request.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];
      final userData = responseData['user'];

      // Проверка, что ID в JWT = ID в user объекте
      final jwtUserId = _getUserIdFromJwt(token);
      if (jwtUserId != userData['id']) {
        throw Exception('User ID in JWT does not match user object');
      }

      return AuthResponse(
        token: token,
        user: User.fromJson(userData),
      );
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/register'),
      body: json.encode(request.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];
      final userData = responseData['user'];

      // Проверка, что ID в JWT = ID в user объекте
      final jwtUserId = _getUserIdFromJwt(token);
      if (jwtUserId != userData['id']) {
        throw Exception('User ID in JWT does not match user object');
      }

      return AuthResponse(
        token: token,
        user: User.fromJson(userData),
      );
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<void> logout(String token) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to logout: ${response.body}');
    }
  }

  String _getUserIdFromJwt(String jwt) {
    try {
      final decoded = JwtDecoder.decode(jwt);
      return decoded['sub'] ?? decoded['userId']; // Поменять в зависимости от того, как бекенд хранит ID в токене
    } catch (e) {
      throw Exception('Failed to decode JWT: $e');
    }
  }
}