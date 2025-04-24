class ApiConstants {
  static const String baseUrl = 'http://localhost:8080/api/v1';

  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';

  static const String endingsEndpoint = '/user/endings'; // нужно куда-то еще Id пользователя вставить

  static const Duration connectTimeout = Duration(seconds: 5);
  static const Duration receiveTimeout = Duration(seconds: 5);

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}