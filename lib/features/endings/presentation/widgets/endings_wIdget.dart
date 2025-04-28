import 'dart:convert';

import 'package:digital_wind/features/endings/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../core/components/button.dart';

class EndingsWidget extends StatefulWidget {
  final VoidCallback onExitPressed;

  const EndingsWidget({
    super.key,
    required this.onExitPressed,
  });

  @override
  State<EndingsWidget> createState() => _EndingsWidgetState();
}

class _EndingsWidgetState extends State<EndingsWidget> {
  List<dynamic> _endings = [];

  @override
  void initState() {
    super.initState();
    _loadEndings();
  }

  Future<void> _loadEndings() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/endings.json');
      final data = jsonDecode(jsonString);
      setState(() {
        _endings = data['endings'] ?? [];
      });
    } catch (e) {
      debugPrint('Error loading endings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Button(
            text: 'Выйти',
            borderColor: Colors.blue,
            onPressed: widget.onExitPressed,
            spaceBetweenButtons: 12,
          ),
          const SizedBox(height: 20),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _endings.length,
            itemBuilder: (context, index) {
              final ending = _endings[index];
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFB91354)),
                  ),
                  child: Text(
                    ending['title'] ?? 'Без названия',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}