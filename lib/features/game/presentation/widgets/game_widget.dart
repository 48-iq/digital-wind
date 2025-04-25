import 'dart:convert';

import 'package:digital_wind/features/core/components/player_message.dart';
import 'package:digital_wind/features/core/components/system_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameWidget extends StatefulWidget {


  const GameWidget({super.key});

  @override
  State<StatefulWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  Map<String, dynamic> _systemActions = {};
  Map<String, dynamic> _userActions = {};
  List<Map<String, dynamic>> _messages = [];

  Future<void> loadJsonAsset() async { 
    final String jsonString = await rootBundle.loadString('assets/story.json'); 
    final data = jsonDecode(jsonString); 
    setState(() { 
      _systemActions = data['systemActions']; 
      _userActions = data['userActions']; 
    });
  }

  void _addMessage(String text, {bool isSystem = true, Function()? onCompleted}) {
    String id = '${DateTime.now().millisecondsSinceEpoch}${_messages.length}';
    setState(() {  
      _messages.add({
        'id': id,
        'text': text,
        'isSystem': isSystem,
        'isTyping': true,
        'onCompleted': () {
          onCompleted?.call();
          for (var i = 0; i < _messages.length; i++) {
            if (_messages[i]['id'] == id) {
              _messages[i]['isTyping'] = false;
            }
          }
          setState(() {});
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadJsonAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _messages
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final message = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message['isSystem'])
                SystemMessage(
                  text: message['text'], 
                  isTyping: message['isTyping'], 
                  onCompleted: () => (message['onCompleted'] as Function?)?.call()
                )
              else 
                PlayerMessage(
                  text: message['text'], 
                  isTyping: message['isTyping'], 
                  onCompleted: () => (message['onCompleted'] as Function?)?.call()
                )
            ],
          ),
        );
      }).toList(),
    );
  }
}