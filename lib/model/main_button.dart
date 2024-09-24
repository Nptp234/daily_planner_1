import 'package:daily_planner_1/model/const.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonCustom extends StatelessWidget{

  ButtonCustom({super.key, this.width, this.height, this.color, required this.text, this.textStyle, required this.currentContext});

  BuildContext currentContext;
  double? width, height;
  Color? color;
  String text;
  TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    context = currentContext;
    return Container(
      width: width??getMainWidth(context),
      height: height??60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color??const Color(0xFF0060FF),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Text(text, style: textStyle??const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),),
      ),
    ); 
  }

}