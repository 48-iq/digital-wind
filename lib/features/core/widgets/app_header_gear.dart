import 'package:flutter/material.dart';

class AppHeaderGear extends StatelessWidget {
  final VoidCallback? onTap;

  const AppHeaderGear({super.key, this.onTap});

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 230,
              fit: BoxFit.contain,
            ),
            GestureDetector(
              onTap: onTap,
              child: Image.asset(
                'assets/images/logo_settings.png',
                width: 42,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}