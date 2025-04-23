import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/components/typed_text.dart';
import '../../data/store/auth_store.dart';

class RegisterWidget extends StatefulWidget {
  final Function() onLoginPressed;

  const RegisterWidget({super.key, required this.onLoginPressed});

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [];
  String _currentInputType = 'username';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addSystemMessage('Введите имя пользователя:');
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

  void _onFieldSubmitted(String value) async {
    if (value.isEmpty) return;

    _addUserMessage(value);

    switch (_currentInputType) {
      case 'username':
        _usernameController.text = value;
        await Future.delayed(const Duration(milliseconds: 300));
        _addSystemMessage('Введите email:');
        _currentInputType = 'email';
        break;
      case 'email':
        _emailController.text = value;
        await Future.delayed(const Duration(milliseconds: 300));
        _addSystemMessage('Введите пароль:');
        _currentInputType = 'password';
        break;
      case 'password':
        _passwordController.text = value;
        _addUserMessage(List.filled(value.length, '*').join());
        _currentInputType = '';
        _handleRegister();
        break;
    }

    setState(() {});
  }

  Future<void> _handleRegister() async {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _emailController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Provider.of<AuthStore>(context, listen: false).register(
      _usernameController.text,
      _emailController.text,
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
        // История сообщений
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
                                color: Colors.blue), // Синий цвет для системы
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
                                color: Color(0xFFB91354)), // Розовый цвет для игрока
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

        // Поле ввода
        if (_currentInputType.isNotEmpty)
          Row(
            children: [
              const Text(
                '> ',
                style: TextStyle(color: Colors.white, fontFamily: 'Courier'),
              ),
              Expanded(
                child: TextField(
                  controller: _currentInputType == 'username'
                      ? _usernameController
                      : _currentInputType == 'email'
                      ? _emailController
                      : _passwordController,
                  autofocus: true,
                  obscureText: _currentInputType == 'password',
                  keyboardType: _currentInputType == 'email' ? TextInputType
                      .emailAddress : TextInputType.text,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Courier'),
                  decoration: const InputDecoration(
                    hintText: '', // Убираем hintText
                    border: InputBorder.none,
                  ),
                  onSubmitted: _onFieldSubmitted,
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
                onPressed: widget.onLoginPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFB91354)),
                ),
                child: const Text(
                  'Уже есть аккаунт? Войти',
                  style: TextStyle(color: Color(0xFFB91354)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}