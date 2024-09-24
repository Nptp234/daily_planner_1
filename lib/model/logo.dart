import 'package:daily_planner_1/model/const.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Logo extends StatelessWidget{

  double size = 125;

  Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Icon(Icons.topic_outlined, size: size/2, color: Colors.white,),
      ),
    );
  }

}