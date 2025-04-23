import 'package:flutter/material.dart';

class TypedText extends StatefulWidget {
  final String text;
  final Duration speed;
  final TextStyle? style;
  final VoidCallback? onCompleted;

  const TypedText({
    super.key,
    required this.text,
    this.speed = const Duration(milliseconds: 50),
    this.style,
    this.onCompleted,
  });

  @override
  _TypedTextState createState() => _TypedTextState();
}

class _TypedTextState extends State<TypedText> {
  late String _displayText;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _displayText = '';
    _currentIndex = 0;
    _typeText();
  }

  void _typeText() {
    if (_currentIndex < widget.text.length) {
      setState(() {
        _displayText += widget.text[_currentIndex];
        _currentIndex++;
      });
      Future.delayed(widget.speed, _typeText);
    } else {
      widget.onCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style ?? const TextStyle(color: Colors.white, fontFamily: 'Courier'),
    );
  }
}