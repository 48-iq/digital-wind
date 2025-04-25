import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed  
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFB91354)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Color(0xFFB91354)),
      ),
    );
    
  }
}