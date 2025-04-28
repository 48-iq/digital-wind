import 'package:digital_wind/features/endings/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/components/button.dart';

class EndingsWidget extends StatelessWidget {
  final VoidCallback onExitPressed;

  // Временный список концовок
  final List<String> endings = [
    "Концовка 1: Вы спасли королевство",
    "Концовка 2: Вы стали правителем тьмы",
    "Концовка 3: Вы нашли древний артефакт",
    "Концовка 4: Вы заключили мир между народами",
    "Концовка 5: Вы открыли портал в другой мир",
  ];

  EndingsWidget({
    super.key,
    required this.onExitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(
            text: 'Выйти',
            borderColor: Colors.blue,
            onPressed: onExitPressed,
            spaceBetweenButtons: 12,
          ),
          const SizedBox(height: 20),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: endings.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: CustomText(
                    text: endings[index],
                    borderColor: const Color(0xFFB91354)
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}