import 'package:flutter/material.dart';
import '../../../core/widgets/app_header.dart';
import '../widgets/quick_menu_widget.dart';

class QuickMenuPage extends StatelessWidget {
  final VoidCallback onContinuePressed;
  final VoidCallback onExitPressed;

  const QuickMenuPage({
    super.key,
    required this.onContinuePressed,
    required this.onExitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const AppHeader(),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: QuickMenuWidget(
                onContinuePressed: onContinuePressed,
                onExitPressed: onExitPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}