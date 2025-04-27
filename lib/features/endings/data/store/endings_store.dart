import 'package:flutter/cupertino.dart';

import '../../../core/entities/store_status.dart';
import '../api/endings_api.dart';
import '../entities/endings_response.dart';

class EndingsStore extends ChangeNotifier {
  final EndingsApi endingApi;
  List<
      EndingsResponse> _openedEndings = [];
  StoreStatus _status = StoreStatus.success;

  EndingsStore({required this.endingApi});

  List<EndingsResponse> get openedEndings => _openedEndings;
  StoreStatus get status => _status;

  Future<void> fetchOpenedEndings(String token) async {
    try {
      _status = StoreStatus.loading;
      notifyListeners();

      _openedEndings = await endingApi.getOpenedEndings(token);

      _status = StoreStatus.success;
      notifyListeners();
    } catch (e) {
      _status = StoreStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> openNewEnding(String id, String token) async {
    try {
      _status = StoreStatus.loading;
      notifyListeners();

      final newEnding = await endingApi.openEnding(id, token);
      _openedEndings.add(newEnding);

      _status = StoreStatus.success;
      notifyListeners();
    } catch (e) {
      _status = StoreStatus.error;
      notifyListeners();
      rethrow;
    }
  }
}