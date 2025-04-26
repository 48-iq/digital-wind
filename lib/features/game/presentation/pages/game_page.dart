
import 'package:digital_wind/features/core/widgets/app_header.dart';
import 'package:digital_wind/features/game/presentation/widgets/game_widget.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/app_header_gear.dart';

class GamePage extends StatelessWidget {

  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppHeaderGear(),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: GameWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}