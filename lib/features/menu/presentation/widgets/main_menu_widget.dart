import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/data/store/auth_store.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../core/components/button.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_header_gear.dart';
import '../../../endings/presentation/pages/endings_page.dart';
import '../../../game/presentation/pages/game_page.dart';

class MainMenuWidget extends StatelessWidget {
  void onPlayPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamePage()),
    );
  }

  void onEndingsPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EndingsPage()),
    );
  }

  void onLogoutPressed(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    authStore.logout().then((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
      );
    });
  }

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
          onPressed: () => onPlayPressed(context),
          spaceBetweenButtons: 12,
        ),
        const SizedBox(height: 20),
        Button(
          text: 'Концовки',
          borderColor: const Color(0xFFB91354),
          onPressed: () => onEndingsPressed(context),
          spaceBetweenButtons: 12,
        ),
        const SizedBox(height: 20),
        Button(
          text: 'Выйти',
          borderColor: Colors.blue,
          onPressed: () => onLogoutPressed(context),
          spaceBetweenButtons: 12,
        ),
      ],
    );
  }
}