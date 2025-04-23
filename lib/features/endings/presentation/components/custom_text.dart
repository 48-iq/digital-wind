import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color borderColor;

  const CustomText({
    super.key,
    required this.text,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1), // Thinner border
          padding: const EdgeInsets.symmetric(vertical: 12), // Adjust padding if needed
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
    );
  }
}