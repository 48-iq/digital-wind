
import 'package:flutter/material.dart';

class SystemMessageHeader extends StatelessWidget {
  const SystemMessageHeader({
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
            text: 'система',
            style: const TextStyle(
                color: Colors.blue),
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