import 'package:flutter/material.dart';
import '../../../core/widgets/app_header.dart';
import '../widgets/register_widget.dart';

class RegisterPage extends StatelessWidget {
  final Function() onLoginPressed;

  const RegisterPage({super.key, required this.onLoginPressed});

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
                child: RegisterWidget(onLoginPressed: onLoginPressed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}