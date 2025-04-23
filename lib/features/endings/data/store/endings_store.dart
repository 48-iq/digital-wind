import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../api/endings_api.dart';
import '../entities/all_ending_request.dart';

class EndingsStore extends ChangeNotifier {
  final EndingsApi _endingsApi;
  List<String> _endings = [];
  bool _isLoading = false;
  String? _error;

  List<String> get endings => _endings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  EndingsStore({EndingsApi? endingsApi})
      : _endingsApi = endingsApi ?? EndingsApi(client: http.Client());

  Future<void> loadEndings(String token) async {
    try {
      _startLoading();
      final response = await _endingsApi.getAllEndings(token);
      _endings = response.endings;
      notifyListeners();
    } catch (e) {
      _handleError(e);
    } finally {
      _stopLoading();
    }
  }

  Future<void> addEnding(String endingId, String token) async {
    try {
      _startLoading();
      await _endingsApi.postEnding(AllEndingRequest(endingId), token);
      await loadEndings(token);
    } catch (e) {
      _handleError(e);
    } finally {
      _stopLoading();
    }
  }

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
}