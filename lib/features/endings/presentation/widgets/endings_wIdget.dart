import 'package:digital_wind/features/endings/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EndingsWidget extends StatelessWidget{
  final List<String> endings;

  const EndingsWidget({super.key, required this.endings});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //TODO поменять на кнопку
          CustomText(text: "Выйти в меню", borderColor: Color(0XFF1074A5)),
          
          ListView.builder(
          scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: endings.length,
            itemBuilder: (context, index){
              return Padding(
                  padding: const EdgeInsets.all(10),
                  child:  CustomText(text: endings[index], borderColor: Color(0XFF1074A5))
              );
            },
          )
        ],
      )
    );
  }
}