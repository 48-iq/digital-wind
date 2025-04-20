import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String text;

  const AuthHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 18,
          fontFamily: 'Courier',
        ),
      ),
    );
  }
}