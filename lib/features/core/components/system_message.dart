import 'package:digital_wind/features/core/components/system_message_header.dart';
import 'package:digital_wind/features/core/components/typed_text.dart';
import 'package:flutter/material.dart';

class SystemMessage extends StatefulWidget {
  final String text;
  final bool isTyping;
  final VoidCallback? onCompleted;
  final VoidCallback? onType;

  const SystemMessage({
    super.key,
    this.onType,
    required this.text,
    required this.isTyping,
    required this.onCompleted
  });

  @override
  State<SystemMessage> createState() => _SystemMessageState();
}

class _SystemMessageState extends State<SystemMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            const SystemMessageHeader(),

          if (widget.isTyping)
            TypedText(
              text: widget.text,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Courier',
              ),
              onType: widget.onType,
              onCompleted: widget.onCompleted
            )
          else
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Courier',
              ),
            ),
        ],
      ),
    );
  }
}