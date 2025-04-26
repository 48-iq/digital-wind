import 'package:flutter/material.dart';
import '../../../core/components/button.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_header_gear.dart';
import '../pages/main_menu_page.dart';

class QuickMenuWidget extends StatelessWidget {
  const QuickMenuWidget({super.key});

  void _onContinuePressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _onExitPressed(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainMenuPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Button(
          text: 'Продолжить',
          borderColor: const Color(0xFFB91354),
          onPressed: () => _onContinuePressed(context),
          spaceBetweenButtons: 12,
        ),
        const SizedBox(height: 20),
        Button(
          text: 'Выйти в меню',
          borderColor: Colors.blue,
          onPressed: () => _onExitPressed(context),
          spaceBetweenButtons: 12,
        ),
      ],
    );
  }
}