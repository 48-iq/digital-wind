import 'package:flutter/material.dart';

import '../../../core/widgets/app_header.dart';
import '../widgets/endings_wIdget.dart';

class AllEndingsPage extends StatelessWidget {
  final List<String> endings;

  const AllEndingsPage({super.key, required this.endings});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppHeader(),
                const SizedBox(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    child: EndingsWidget(endings: endings,),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}