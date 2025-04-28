import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/components/button.dart';
import '../../../core/components/system_message.dart';

class EndingWidget extends StatefulWidget {
  final String endingText;
  final VoidCallback onComplete;

  const EndingWidget({
    super.key,
    required this.endingText,
    required this.onComplete,
  });

  @override
  State<EndingWidget> createState() => _EndingWidgetState();
}

class _EndingWidgetState extends State<EndingWidget> {
  final List<Map<String, dynamic>> _messages = [];
  bool _showButton = false;
  bool _isAnyTyping = false;
  String _displayedEndingText = "";
  int _currentEndingCharIndex = 0;
  late Timer _typingTimer;

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
  }

  @override
  void dispose() {
    _typingTimer.cancel();
    super.dispose();
  }

  void _addInitialMessage() {
    _addMessage(
      "Вы открыли концовку!",
      isSystem: true,
      onCompleted: _startTypingEndingText,
    );
  }

  void _startTypingEndingText() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_currentEndingCharIndex < widget.endingText.length) {
        setState(() {
          _displayedEndingText = widget.endingText.substring(0, _currentEndingCharIndex + 1);
          _currentEndingCharIndex++;
          _updateMessageText();
        });
      } else {
        timer.cancel();
        setState(() {
          _showButton = true;
        });
      }
    });
  }

  void _updateMessageText() {
    if (_messages.isNotEmpty) {
      setState(() {
        _messages[0]['text'] = [
          "Вы открыли концовку!",
          if (_displayedEndingText.isNotEmpty) _displayedEndingText,
        ].join('\n\n');
      });
    }
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
          setState(() {
            _messages.firstWhere((m) => m['id'] == id)['isTyping'] = false;
            _updateTypingStatus();
          });
        }
      });
      _updateTypingStatus();
    });
  }

  void _updateTypingStatus() {
    setState(() {
      _isAnyTyping = _messages.any((m) => m['isTyping'] == true) ||
          _currentEndingCharIndex < widget.endingText.length;
    });
  }

  void _stopAllTyping() {
    setState(() {
      for (var message in _messages) {
        if (message['isTyping'] == true) {
          message['isTyping'] = false;
          message['onCompleted']?.call();
        }
      }

      _typingTimer.cancel();
      _displayedEndingText = widget.endingText;
      _currentEndingCharIndex = widget.endingText.length;

      _updateMessageText();
      _updateTypingStatus();
      _showButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _isAnyTyping ? _stopAllTyping : null,
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _messages.map((message) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SystemMessage(
                      text: message['text'],
                      isTyping: message['isTyping'],
                      onCompleted: message['onCompleted'],
                    ),
                  );
                }).toList(),
              ),
              if (_showButton)
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Button(
                    text: 'Выйти в меню',
                    borderColor: Colors.blue,
                    onPressed: widget.onComplete,
                    spaceBetweenButtons: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}