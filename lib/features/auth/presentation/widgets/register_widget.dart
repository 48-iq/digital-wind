import 'package:digital_wind/features/auth/data/entities/login_response.dart';
import 'package:digital_wind/features/auth/data/entities/register_request.dart';
import 'package:digital_wind/features/auth/presentation/components/auth_button.dart';
import 'package:digital_wind/features/auth/presentation/components/text_input.dart';
import 'package:digital_wind/features/core/components/player_message.dart';
import 'package:digital_wind/features/core/components/system_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../menu/presentation/pages/main_menu_page.dart';
import '../../data/store/auth_store.dart';

class RegisterWidget extends StatefulWidget {
  final Function() onLoginPressed;

  const RegisterWidget({super.key, required this.onLoginPressed});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {

  // username text input
  final _usernameController = TextEditingController();
  bool _showUsernameField = false;

  //password text input
  final _passwordController = TextEditingController();
  bool _showPasswordField = false;

  //email text input
  final _emailController = TextEditingController();
  bool _showEmailField = false;

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
      _showEmailField = true;
      _addMessage('Введите email:');
    });
  }

  void _onEmailSubmitted(String value) async {
    if (value.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 300));
    _showEmailField = false;
    _addMessage(value, isSystem: false, onCompleted: () async {
      await Future.delayed(const Duration(milliseconds: 300));
      _showPasswordField = true;
      _addMessage('Введите пароль:');
    });
  }

  Future<void> _handleRegister(String value) async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    _showPasswordField = false;
    _addMessage(List.filled(_passwordController.text.length, '*').join(), isSystem: false);

    final authStore = Provider.of<AuthStore>(context, listen: false);
    await authStore.register(
        RegisterRequest(
            username: _usernameController.text,
            password: _passwordController.text,
            email: _emailController.text
        )
    );

    if (authStore.token != null) {
      await Future.delayed(const Duration(milliseconds: 300));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainMenuPage())
      );
    } else {
      _addMessage('Ошибка регистрации. Попробуйте снова...');
      await Future.delayed(const Duration(seconds: 3));

      _usernameController.clear();
      _passwordController.clear();
      _emailController.clear();
      _messages.clear();

      _addMessage('Введите имя пользователя:');
      _showUsernameField = true;
      setState(() {});
    }
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

        if (_showEmailField)
          TextInput(
            obscureText: false,
            controller: _emailController,
            handleEnter: _onEmailSubmitted,
        ),

        if (_showPasswordField)
          TextInput(
            obscureText: true,
            controller: _passwordController,
            handleEnter: _handleRegister,
          ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: AuthButton(
                text: 'Есть аккаунт? Войти',
                onPressed: widget.onLoginPressed,
              ),
          )
        )
      ],
    );
  }
}