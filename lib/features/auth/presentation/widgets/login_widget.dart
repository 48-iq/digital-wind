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
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [];
  bool _showUsernameField = false;
  bool _showPasswordField = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addSystemMessage('Введите имя пользователя:');
    _showUsernameField = true;
  }

  void _addSystemMessage(String text) {
    _messages.add({
      'text': text,
      'isSystem': true,
      'isTyping': true,
    });
    setState(() {});
  }

  void _addUserMessage(String text) {
    _messages.add({
      'text': text,
      'isSystem': false,
      'isTyping': false,
    });
    setState(() {});
  }

  void _completeTyping(int index) {
    _messages[index]['isTyping'] = false;
    setState(() {});
  }

  void _onUsernameSubmitted(String value) async {
    if (value.isEmpty) return;

    _addUserMessage(value);
    _showUsernameField = false;

    await Future.delayed(const Duration(milliseconds: 300));
    _addSystemMessage('Введите пароль:');
    _showPasswordField = true;
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    _addUserMessage(List.filled(_passwordController.text.length, '*').join());
    _showPasswordField = false;

    setState(() {
      _isLoading = true;
    });

    await Provider.of<AuthStore>(context, listen: false).login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });
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
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                              text: '[',
                              style: TextStyle(color: Colors.white)
                          ),
                          TextSpan(
                            text: 'система',
                            style: const TextStyle(
                                color: Colors.blue),
                          ),
                          const TextSpan(
                              text: ']',
                              style: TextStyle(color: Colors.white)
                          ),
                        ],
                      ),
                    ),

                  if (!message['isTyping'] && !message['isSystem'])
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                              text: '[',
                              style: TextStyle(color: Colors.white)
                          ),
                          TextSpan(
                            text: 'игрок',
                            style: const TextStyle(
                                color: Color(0xFFB91354)),
                          ),
                          const TextSpan(
                              text: ']',
                              style: TextStyle(color: Colors.white)
                          ),
                        ],
                      ),
                    ),

                  if (message['isTyping'])
                    TypedText(
                      text: message['text'],
                      style: TextStyle(
                        color: message['isSystem'] ? Colors.white : Colors
                            .white,
                        fontFamily: 'Courier',
                      ),
                      onCompleted: () => _completeTyping(index),
                    )
                  else
                    Text(
                      message['isSystem']
                          ? message['text']
                          : '> ${message['text']}',
                      style: TextStyle(
                        color: message['isSystem'] ? Colors.white : Colors
                            .white,
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

        if (_isLoading)
          const TypedText(
            text: '[система]\nloading \\',
            style: TextStyle(color: Colors.white),
          ),

        if (!_isLoading)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: OutlinedButton(
                onPressed: widget.onRegisterPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFB91354)),
                ),
                child: const Text(
                  'Перейти к регистрации',
                  style: TextStyle(color: Color(0xFFB91354)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}