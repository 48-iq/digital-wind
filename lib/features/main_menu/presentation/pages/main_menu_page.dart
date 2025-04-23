import 'package:flutter/material.dart';
import '../widgets/main_menu_widget.dart';

class MainMenuPage extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onEndingsPressed;
  final VoidCallback onLogoutPressed;

  const MainMenuPage({
    super.key,
    required this.onPlayPressed,
    required this.onEndingsPressed,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40), // Add padding to the top
          child: MainMenuWidget(
            onPlayPressed: onPlayPressed,
            onEndingsPressed: onEndingsPressed,
            onLogoutPressed: onLogoutPressed,
          ),
        ),
      ),
    );
  }
}