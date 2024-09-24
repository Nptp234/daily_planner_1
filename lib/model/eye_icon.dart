import 'package:flutter/material.dart';

class EyeIcon extends StatefulWidget{
  const EyeIcon({super.key});

  @override
  State<EyeIcon> createState() => _EyeIcon();
}

class _EyeIcon extends State<EyeIcon>{ 

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.remove_red_eye_outlined, size: 30, color: Colors.grey);
  }

}