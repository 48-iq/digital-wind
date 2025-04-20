import 'package:flutter/material.dart';
import '../../../core/widgets/app_header.dart';
import '../widgets/login_widget.dart';

class LoginPage extends StatelessWidget {
  final Function() onRegisterPressed;

  const LoginPage({super.key, required this.onRegisterPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeader(title: '[ NEO HISTORY ]'),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: LoginWidget(onRegisterPressed: onRegisterPressed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}