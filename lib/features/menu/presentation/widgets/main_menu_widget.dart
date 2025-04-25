import 'package:flutter/material.dart';
import '../../../core/components/button.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_header_gear.dart';

class MainMenuWidget extends StatelessWidget {
  void onPlayPressed() {}
  void onEndingsPressed() {}
  void onLogoutPressed() {}

  const MainMenuWidget({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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