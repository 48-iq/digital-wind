import 'package:flutter/material.dart';
import '../../../core/components/button.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_header_gear.dart';

class MainMenuWidget extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onEndingsPressed;
  final VoidCallback onLogoutPressed;

  const MainMenuWidget({
    super.key,
    required this.onPlayPressed,
    required this.onEndingsPressed,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(),
        const SizedBox(height: 40),
        Button(
          text: 'Играть',
          borderColor: const Color(0xFFB91354),
          onPressed: onPlayPressed,
        ),
        const SizedBox(height: 20),
        Button(
          text: 'Концовки',
          borderColor: const Color(0xFFB91354),
          onPressed: onEndingsPressed,
        ),
        const SizedBox(height: 20),
        Button(
          text: 'Выйти',
          borderColor: Colors.blue,
          onPressed: onLogoutPressed,
        ),
      ],
    );
  }
}