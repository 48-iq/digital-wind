import 'package:flutter/material.dart';
import '../../../core/components/button.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_header_gear.dart';

class QuickMenuWidget extends StatelessWidget {
  final VoidCallback onContinuePressed;
  final VoidCallback onExitPressed;

  const QuickMenuWidget({
    super.key,
    required this.onContinuePressed,
    required this.onExitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Button(
          text: 'Продолжить',
          borderColor: const Color(0xFFB91354),
          onPressed: onContinuePressed,
        ),
        const SizedBox(height: 20),
        Button(
          text: 'Выйти в меню',
          borderColor: Colors.blue,
          onPressed: onExitPressed,
        ),
      ],
    );
  }
}