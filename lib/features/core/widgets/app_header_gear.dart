import 'package:flutter/material.dart';

import '../../menu/presentation/pages/quick_menu_page.dart';

class AppHeaderGear extends StatelessWidget {
  const AppHeaderGear({super.key});

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuickMenuPage()),
                );
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Image.asset(
                  'assets/images/logo_settings.png',
                  width: 42,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}