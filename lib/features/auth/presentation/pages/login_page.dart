import 'package:digital_wind/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/app_header.dart';
import '../widgets/login_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  void _onRegisterPressed(context) {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const RegisterPage())
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeader(),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: LoginWidget(onRegisterPressed: () => _onRegisterPressed(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}