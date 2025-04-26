import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Color borderColor;
  final VoidCallback onPressed;
  final double spaceBetweenButtons;

  const Button({
    super.key,
    required this.text,
    required this.borderColor,
    required this.onPressed,
    required this.spaceBetweenButtons
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spaceBetweenButtons, horizontal: 13),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: borderColor, width: 1),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Courier',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}

//fixed