import 'dart:convert';

import 'package:digital_wind/features/core/components/player_message.dart';
import 'package:digital_wind/features/core/components/system_message.dart';
import 'package:digital_wind/features/game/presentation/widgets/player_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/components/button.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:digital_wind/features/core/components/player_message.dart';
import 'package:digital_wind/features/core/components/system_message.dart';
import '../../../core/components/button.dart';
import '../../../menu/presentation/pages/main_menu_page.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({super.key});

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
          setState(() {
            _messages.firstWhere((m) => m['id'] == id)['isTyping'] = false;
          });
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

      if (action['type'] == 'ending') {
        return;
      }

      debugPrint('--- Action History ---');
      for (var action in _actionHistory) {
        debugPrint('${action['type']}: ${action['id']}');
      }
      debugPrint('----------------------');

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

      debugPrint('--- Action History ---');
      for (var action in _actionHistory) {
        debugPrint('${action['type']}: ${action['id']}');
      }
      debugPrint('----------------------');

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._messages.map((message) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message['isSystem'])
                  SystemMessage(
                    text: message['text'],
                    isTyping: message['isTyping'],
                    onCompleted: () =>
                        (message['onCompleted'] as Function?)?.call(),
                  )
                else
                  PlayerMessage(
                    text: message['text'],
                    isTyping: message['isTyping'],
                    onCompleted: () =>
                        (message['onCompleted'] as Function?)?.call(),
                  ),
              ],
            ),
          );
        }).toList(),

        if (_currentPlayerActionIds != null)
          PlayerActionButtons(
            actionIds: _currentPlayerActionIds!,
            playerActions: _playerActions,
            onActionSelected: _selectPlayerAction,
          ),
      ],
    );
  }
}