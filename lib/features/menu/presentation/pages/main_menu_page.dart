import 'package:flutter/material.dart';
import '../../../core/widgets/app_header.dart';
import '../widgets/main_menu_widget.dart';

class MainMenuPage extends StatelessWidget {

  const MainMenuPage({
    super.key
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
              child: MainMenuWidget(),
            ),
          ],
        ),
      ),
    );
  }
}