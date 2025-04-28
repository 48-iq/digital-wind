import 'package:digital_wind/features/core/components/player_message.dart';
import 'package:digital_wind/features/core/components/system_message.dart';
import 'package:digital_wind/features/game/presentation/components/player_action_buttons.dart';
import 'package:flutter/material.dart';

class GameMessages extends StatelessWidget {
  List<dynamic> _sysActions;
  List<dynamic> _playerActions;
  List<Map<String, dynamic>> _messages;
  List<String>? _currentPlayerActionIds;
  List<Map<String, String>> _actionHistory;
  VoidCallback _moveScrollDown;
  Function(String) _selectPlayerAction;
  GameMessages({
    super.key,
    required List<dynamic> sysActions,
    required List<dynamic> playerActions,
    required List<Map<String, dynamic>> messages,
    required List<String>? currentPlayerActionIds,
    required List<Map<String, String>> actionHistory,
    required VoidCallback moveScrollDown,
    required Function(String) selectPlayerAction
  }): _sysActions = sysActions,
      _playerActions = playerActions,
      _messages = messages,
      _currentPlayerActionIds = currentPlayerActionIds,
      _actionHistory = actionHistory,
      _moveScrollDown = moveScrollDown,
      _selectPlayerAction = selectPlayerAction
  ;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ ..._messages.map((message) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message['isSystem'])
                  SystemMessage(
                    text: message['text'],
                    isTyping: message['isTyping'],
                    onType: () => _moveScrollDown(),
                    onCompleted: () =>
                        (message['onCompleted'] as Function?)?.call(),
                  )
                else
                  PlayerMessage(
                    text: message['text'],
                    isTyping: message['isTyping'],
                    onType: () => _moveScrollDown(),
                    onCompleted: () =>
                        (message['onCompleted'] as Function?)?.call(),
                  ),
              ],
            ),
          );
        }), 
        if (_currentPlayerActionIds != null) 
          PlayerActionButtons(
            onInit: _moveScrollDown,
            actionIds: _currentPlayerActionIds!,
            playerActions: _playerActions,
            onActionSelected: _selectPlayerAction,
          ),
        ],
      );
  }
}