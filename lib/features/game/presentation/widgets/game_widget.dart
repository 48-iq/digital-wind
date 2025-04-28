import 'dart:convert';

import 'package:digital_wind/features/game/presentation/components/game_messages.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../auth/data/store/auth_store.dart';
import '../../../endings/data/store/endings_store.dart';

class GameWidget extends StatefulWidget {

  final ScrollController? scrollController;

  const GameWidget({super.key, this.scrollController});

  @override
  State<StatefulWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {


  List<dynamic> _sysActions = [];
  List<dynamic> _playerActions = [];
  List<Map<String, dynamic>> _messages = [];
  List<String>? _currentPlayerActionIds;
  List<Map<String, String>> _actionHistory = [];

  Future<void> loadJsonAsset() async {
    try {
      final String jsonString = await rootBundle.loadString(
          'assets/story.json');
      final data = jsonDecode(jsonString);
      setState(() {
        _sysActions = data['sysActions'] ?? [];
        _playerActions = data['playerActions'] ?? [];
      });
    } catch (e) {
      debugPrint('Error loading JSON: $e');
      _addMessage('Произошла ошибка при загрузке игры', isSystem: true);
    }
  }

  void _onOpenNewEnding(String endingId){
    final endingsStore = Provider.of<EndingsStore>(context, listen: false);
    final authStore = Provider.of<AuthStore>(context, listen: false);
    final token = authStore.token;
    endingsStore.openNewEnding(endingId, token!);
  }

  void _addMessage(String text,
      {bool isSystem = true, Function()? onCompleted}) {
    String id = '${DateTime
        .now()
        .millisecondsSinceEpoch}${_messages.length}';
    setState(() {
      _messages.add({
        'id': id,
        'text': text,
        'isSystem': isSystem,
        'isTyping': true,
        'onCompleted': () {
          onCompleted?.call();
          
          _messages.firstWhere((m) => m['id'] == id)['isTyping'] = false;
          
        }
      });
    });
  }

  bool _checkCondition(List<dynamic>? conditions) {
    if (conditions == null) return true;

    for (var condition in conditions) {
      final actionId = condition['id'];
      final requiredCount = condition['count'];

      final actualCount = _actionHistory
          .where((action) => action['id'] == actionId)
          .length;

      if (actualCount < requiredCount) {
        return false;
      }
    }
    return true;
  }

  String? _getNextSysActionId(List<dynamic> sysActions) {
    if (sysActions.isEmpty) return null;

    for (var sysAction in sysActions) {
      final condition = sysAction['condition'];
      if (_checkCondition(condition)) {
        return sysAction['id'];
      }
    }
    return null;
  }

  void _moveScrollDown() {
    widget.scrollController?.animateTo(
      widget.scrollController?.position.maxScrollExtent??0, 
      duration: const Duration(milliseconds: 100), 
      curve: Curves.linear
    );
  }

  void _stopAllTyping() {
    setState(() {
      for (Map<String, dynamic> message in _messages) {
        message['isTyping'] = false;
      }
    });
  }

  void _showSystemAction(String actionId) {
    final action = _sysActions.firstWhere(
          (action) => action['id'] == actionId,
      orElse: () => null,
    );

    if (action != null) {
      _actionHistory.add({
        'type': 'system',
        'id': actionId,
      });

      if(action["type"] == "ending"){
        _onOpenNewEnding(actionId);
      }

      for (var action in _actionHistory) {
        debugPrint('${action['type']}: ${action['id']}');
      }

      _addMessage(
        action['text'],
        isSystem: true,
        onCompleted: () {
          setState(() {
            _currentPlayerActionIds =
            List<String>.from(action['playerActionIds'] ?? []);
          });
        },
      );
    }
  }

  void _selectPlayerAction(String actionId) {
    final action = _playerActions.firstWhere(
          (action) => action['id'] == actionId,
      orElse: () => null,
    );

    if (action != null) {
      _actionHistory.add({
        'type': 'player',
        'id': actionId,
      });

      for (var action in _actionHistory) {
        debugPrint('${action['type']}: ${action['id']}');
      }

      setState(() {
        _currentPlayerActionIds = null;
      });

      _addMessage(
        action['text'],
        isSystem: false,
        onCompleted: () {
          if (action['sysActions'] != null && action['sysActions'].isNotEmpty) {
            final nextSysActionId = _getNextSysActionId(action['sysActions']);
            if (nextSysActionId != null) {
              _showSystemAction(nextSysActionId);
            }
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadJsonAsset().then((_) {
      _showSystemAction("start");
    });
  }

  bool _isAnyTyping() {
    for (dynamic message in _messages) {
      if (message['isTyping'] == true);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isAnyTyping()) {
      return 
      
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _stopAllTyping(),
        child: GameMessages(
          sysActions: _sysActions, 
          playerActions: _playerActions, 
          messages: _messages, 
          currentPlayerActionIds: _currentPlayerActionIds, 
          actionHistory: _actionHistory, 
          moveScrollDown: _moveScrollDown, 
          selectPlayerAction: _selectPlayerAction
        )
      );
    }
    else {

      return GameMessages(
        sysActions: _sysActions, 
        playerActions: _playerActions, 
        messages: _messages, 
        currentPlayerActionIds: _currentPlayerActionIds, 
        actionHistory: _actionHistory, 
        moveScrollDown: _moveScrollDown, 
        selectPlayerAction: _selectPlayerAction
      );
    }

  }
}