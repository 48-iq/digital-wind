import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_header_gear.dart';
import '../../../menu/presentation/pages/main_menu_page.dart';
import '../widgets/ending_widget.dart';

class EndingPage extends StatelessWidget {
  final String endingText;

  const EndingPage({super.key, required this.endingText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: EndingWidget(
                endingText: endingText,
                onComplete: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainMenuPage()),
                        (route) => false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}