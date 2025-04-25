
import 'package:digital_wind/features/core/components/player_message_header.dart';
import 'package:digital_wind/features/core/components/system_message_header.dart';
import 'package:digital_wind/features/core/components/typed_text.dart';
import 'package:flutter/material.dart';

class PlayerMessage extends StatefulWidget {
  final String text;
  final bool isTyping;
  final VoidCallback? onCompleted;

  const PlayerMessage({
    super.key,
    required this.text,
    required this.isTyping,
    required this.onCompleted
  });

  @override
  State<PlayerMessage> createState() => _SystemMessageState();
}

class _SystemMessageState extends State<PlayerMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            const PlayerMessageHeader(),

          if (widget.isTyping)
            TypedText(
              text:'> ${widget.text}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Courier',
              ),
              onCompleted: widget.onCompleted
            )
          else
            Text(
              '> ${widget.text}',
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