import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final VoidCallback? handleEnter;
  final TextEditingController? controller;
  final bool? obscureText;
  const TextInput({
    super.key,
    required this.controller,
    required this.handleEnter,
    required this.obscureText
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '> ',
          style: TextStyle(color: Colors.white, fontFamily: 'Courier'),
        ),
        Expanded(
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText ?? false,
            autofocus: true,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Courier'),
            decoration: const InputDecoration(
              hintText: '', // Убираем hintText
              border: InputBorder.none,
            ),
            onSubmitted: (_) => widget.handleEnter,
          ),
        ),
      ],
    );
  }
}