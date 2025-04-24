import 'package:digital_wind/features/auth/data/entities/login_response.dart';
import 'package:digital_wind/features/core/components/player_message_header.dart';
import 'package:digital_wind/features/core/components/system_message_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/components/typed_text.dart';
import '../../data/store/auth_store.dart';

class LoginWidget extends StatefulWidget {
  final Function() onRegisterPressed;

  const LoginWidget({super.key, required this.onRegisterPressed});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  // text inputs
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // messages
  final List<Map<String, dynamic>> _messages = [];
  bool _showUsernameField = false;
  bool _showPasswordField = false;

  @override
  void initState() {
    super.initState();
    _addMessage('Введите имя пользователя:');
    _showUsernameField = true;
  }

  void _addMessage(String text, {bool isSystem = true}) {
    setState(() {  
      _messages.add({
        'text': text,
        'isSystem': isSystem,
        'isTyping': true,
      });
    });
  }

  void _completeTyping(int index) {
    _messages[index]['isTyping'] = false;
  }

  void _onUsernameSubmitted(String value) async {
    if (value.isEmpty) return;

    _addMessage(value, isSystem: false);
    _showUsernameField = false;

    await Future.delayed(const Duration(milliseconds: 300));
    _addMessage('Введите пароль:');
    _showPasswordField = true;
  }

  Future<void> _handleLogin() async {
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
                    const SystemMessageHeader(),

                  if (!message['isTyping'] && !message['isSystem'])
                    const PlayerMessageHeader(),

                  if (message['isTyping'])
                    TypedText(
                      text: message['text'],
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Courier',
                      ),
                      onCompleted: () => _completeTyping(index),
                    )
                  else
                    Text(
                      message['isSystem'] ? message['text']: '> ${message['text']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Courier',
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),

        if (_showUsernameField)
          Row(
            children: [
              const Text(
                '> ',
                style: TextStyle(color: Colors.white, fontFamily: 'Courier'),
              ),
              Expanded(
                child: TextField(
                  controller: _usernameController,
                  autofocus: true,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Courier'),
                  decoration: const InputDecoration(
                    hintText: '',
                    border: InputBorder.none,
                  ),
                  onSubmitted: _onUsernameSubmitted,
                ),
              ),
            ],
          ),

        if (_showPasswordField)
          Row(
            children: [
              const Text(
                '> ',
                style: TextStyle(color: Colors.white, fontFamily: 'Courier'),
              ),
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  autofocus: true,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Courier'),
                  decoration: const InputDecoration(
                    hintText: '', // Убираем hintText
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _handleLogin(),
                ),
              ),
            ],
          ),
      ],
    );
  }
}