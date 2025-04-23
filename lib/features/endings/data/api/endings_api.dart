import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';
import '../entities/all_ending_request.dart';
import '../entities/all_ending_response.dart';

class EndingsApi {
  final http.Client client;

  EndingsApi({required this.client});

  Future<AllEndingResponse> getAllEndings(String token) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/endings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return AllEndingResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load endings: ${response.body}');
    }
  }

  Future<void> postEnding(AllEndingRequest request, String token) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/endings'),
      body: json.encode(request.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post ending: ${response.body}');
    }
  }
}