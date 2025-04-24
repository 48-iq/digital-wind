
import 'package:flutter/material.dart';

class PlayerMessageHeader extends StatelessWidget {
  const PlayerMessageHeader({
    super.key});

  @override
  Widget build(BuildContext context) {
     
    return  RichText(
      text: TextSpan(
        children: [
          const TextSpan(
              text: '[',
              style: TextStyle(color: Colors.white)
          ),
          TextSpan(
            text: 'игрок',
            style: const TextStyle(
                color: Color(0xFFB91354)),
          ),
          const TextSpan(
              text: ']',
              style: TextStyle(color: Colors.white)
          ),
        ],
      ),
    );
  }
}

//fixed