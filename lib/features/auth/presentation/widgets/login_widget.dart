import 'package:digital_wind/features/auth/data/entities/login_response.dart';
import 'package:digital_wind/features/auth/presentation/components/text_input.dart';
import 'package:digital_wind/features/core/components/player_message.dart';
import 'package:digital_wind/features/core/components/system_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/store/auth_store.dart';

class LoginWidget extends StatefulWidget {
  final Function() onRegisterPressed;

  const LoginWidget({super.key, required this.onRegisterPressed});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  // username text input
  final _usernameController = TextEditingController();
  bool _showUsernameField = false;

  //password text input
  final _passwordController = TextEditingController();
  bool _showPasswordField = false;

  // messages
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _addMessage('Введите имя пользователя:');
    _showUsernameField = true;
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

  void _onUsernameSubmitted(String value) async {
    if (value.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 300));
    _showUsernameField = false;
    _addMessage(value, isSystem: false, onCompleted: () async {
      await Future.delayed(const Duration(milliseconds: 300));
      _addMessage('Введите пароль:');
      _showPasswordField = true;
    });
  }

  Future<void> _handleLogin(String value) async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    _addMessage(List.filled(_passwordController.text.length, '*').join(), isSystem: false);
    _showPasswordField = false;

    await Provider.of<AuthStore>(context, listen: false).login(
      LoginRequest(username: _usernameController.text, password: _passwordController.text));

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
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
        ),

        if (_showUsernameField)
          TextInput(
            obscureText: false,
            controller: _usernameController,
            handleEnter: _onUsernameSubmitted,
          ),

        if (_showPasswordField)
          TextInput(
            obscureText: true,
            controller: _passwordController,
            handleEnter: _handleLogin,
          ),
      ],
    );
  }
}