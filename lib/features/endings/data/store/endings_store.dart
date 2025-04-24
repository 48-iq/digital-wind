import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/endings_api.dart';
import '../entities/all_ending_request.dart';

class EndingsStore extends ChangeNotifier {
  final EndingsApi _endingsApi;
  List<String> _endings = [];
  bool _isLoading = false;
  String? _error;
  String? _token;

  List<String> get endings => _endings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;

  EndingsStore({EndingsApi? endingsApi})
      : _endingsApi = endingsApi ?? EndingsApi(client: http.Client());

  Future<void> loadEndings(String token) async {
    try {
      _startLoading();
      _token = token;
      final response = await _endingsApi.getAllEndings(token);
      _endings = response.endings;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('user_endings', _endings);

      notifyListeners();
    } catch (e) {
      _handleError(e);
      await _loadCachedEndings();
    } finally {
      _stopLoading();
    }
  }

  Future<void> _loadCachedEndings() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedEndings = prefs.getStringList('user_endings');
    if (cachedEndings != null) {
      _endings = cachedEndings;
      notifyListeners();
    }
  }

  Future<void> addEnding(String endingId, String token) async {
    try {
      _startLoading();
      await _endingsApi.postEnding(AllEndingRequest(endingId), token);

      if (!_endings.contains(endingId)) {
        _endings.add(endingId);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('user_endings', _endings);
      }

      notifyListeners();
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