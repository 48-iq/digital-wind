import 'package:digital_wind/features/endings/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/components/button.dart';
import '../../../core/widgets/app_header.dart';

class EndingsWidget extends StatelessWidget{
  final VoidCallback onExitPressed;
  final List<String> endings;

  const EndingsWidget({super.key, required this.endings, required this.onExitPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              text: 'Выйти',
              borderColor: Colors.blue,
              onPressed: onExitPressed,
            ),
          
          ListView.builder(
          scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: endings.length,
            itemBuilder: (context, index){
              return Padding(
                  padding: const EdgeInsets.all(10),
                  child:  CustomText(text: endings[index], borderColor: Color(0xFFB91354))
              );
            },
          )
        ],
      )
    );
  }
}