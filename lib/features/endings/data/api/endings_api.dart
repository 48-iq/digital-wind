import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/ApiConstants.dart';
import '../entities/ending_request.dart';
import '../entities/endings_response.dart';

class EndingsApi {
  final http.Client client;

  EndingsApi({required this.client});

  Future<List<EndingsResponse>> getOpenedEndings(String token) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/v1/ending/opened'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((json) => EndingsResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load opened endings: ${response.body}');
    }
  }

  Future<EndingsResponse> openEnding(String id, String token) async {
    final request = EndingRequest(id);

    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/v1/ending/open'),
      body: json.encode(request.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return EndingsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to open ending: ${response.body}');
    }
  }
}