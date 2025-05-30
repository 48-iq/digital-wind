import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.transparent,
      width: double.infinity,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF6A0DAD), Color(0xFF8A0C4D)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 230,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}