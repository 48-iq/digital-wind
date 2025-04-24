import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestStore extends ChangeNotifier {
  final SharedPreferences _prefs;
  List<String> _userLog = [];

  List<String> get userLog => _userLog;

  QuestStore(this._prefs) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    _userLog = _prefs.getStringList('user_log') ?? [];
    notifyListeners();
  }

  Future<void> saveAction(String actionId) async {
    _userLog.add(actionId);
    await _prefs.setStringList('user_log', _userLog);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    _userLog = [];
    await _prefs.remove('user_log');
    notifyListeners();
  }
}