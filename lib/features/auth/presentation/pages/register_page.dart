import 'package:digital_wind/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/app_header.dart';
import '../widgets/register_widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key });
  void _onLoginPressed(context) {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LoginPage())
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
                child: RegisterWidget(onLoginPressed: () => _onLoginPressed(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}